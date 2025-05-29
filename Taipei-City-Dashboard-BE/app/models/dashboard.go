// Package models stores the models for the postgreSQL databases.
package models

import (
	"encoding/json"
	"fmt"
	"time"
	"database/sql"

	"TaipeiCityDashboardBE/logs"

	"github.com/lib/pq"
)

/* ----- Models ----- */

type Dashboard struct {
	ID         int           `json:"-"         gorm:"column:id;autoincrement;primaryKey"`
	Index      string        `json:"index" gorm:"column:index;type:varchar;unique;not null"     `
	Name       string        `json:"name"       gorm:"column:name;type:varchar;not null"`
	Components pq.Int64Array `json:"components" gorm:"column:components;type:int[]"`
	Icon       string        `json:"icon"       goem:"column:icon;type:varchar;not null"`
	UpdatedAt  time.Time     `json:"updated_at" gorm:"column:updated_at;type:timestamp with time zone;not null"`
	CreatedAt  time.Time     `json:"-" gorm:"column:created_at;type:timestamp with time zone;not null"`
}

type DashboardGroup struct {
	DashboardID int       `json:"dashboard_id" gorm:"column:dashboard_id;primaryKey"`
	GroupID     int       `json:"group_id"     gorm:"column:group_id;primaryKey"`
	Dashboard   Dashboard `gorm:"foreignKey:DashboardID"`
	Group       Group     `gorm:"foreignKey:GroupID"`
}

/* ----- Handlers ----- */

type allDashboards struct {
	Public      []Dashboard `json:"public"`
	Taipei      []Dashboard `json:"taipei"`
	MetroTaipei []Dashboard `json:"metrotaipei"`
	Personal    []Dashboard `json:"personal"`
}

// Dashboard order models (kept within the same file)
type DashboardOrder struct {
	ID               int       `json:"id"`
	UserID           int       `json:"user_id"`
	City             *string   `json:"city"`
	DashboardIndexes []string  `json:"dashboard_indexes"`
	UpdatedAt        time.Time `json:"_mtime"`
	CreatedAt        time.Time `json:"_ctime"`
}

func GetAllDashboards(accountID int) (dashboards allDashboards, err error) {
	// Get all the public group dashboards
	err = DBManager.
		Joins("JOIN dashboard_groups ON dashboards.id = dashboard_groups.dashboard_id AND dashboard_groups.group_id = ?", 1).
		Order("dashboards.id").
		Find(&dashboards.Public).
		Error

	if err != nil {
		return dashboards, err
	}

	err = DBManager.
		Joins("JOIN dashboard_groups ON dashboards.id = dashboard_groups.dashboard_id").
		Joins("JOIN groups ON dashboard_groups.group_id = groups.id AND groups.is_personal = False AND groups.name = ?", "taipei").
		Order("dashboards.id").
		Find(&dashboards.Taipei).
		Error

	if err != nil {
		return dashboards, err
	}

	err = DBManager.
		Joins("JOIN dashboard_groups ON dashboards.id = dashboard_groups.dashboard_id").
		Joins("JOIN groups ON dashboard_groups.group_id = groups.id AND groups.is_personal = False AND groups.name = ?", "metrotaipei").
		Order("dashboards.id").
		Find(&dashboards.MetroTaipei).
		Error

	if err != nil {
		return dashboards, err
	}

	// Get all the Personal dashboards
	if accountID > 0 {
		subQuery := DBManager.Table("groups").
		Select("id").
		Joins("JOIN auth_user_group_roles as ag ON groups.id = ag.group_id").
		Where("is_personal = true").
		Where("auth_user_id = ?", accountID)

		err = DBManager.Debug().
			Joins("JOIN dashboard_groups as dg ON dashboards.id = dg.dashboard_id AND dg.group_id IN (?)", subQuery).
			Find(&dashboards.Personal).
			Error
	} else {
		dashboards.Personal = []Dashboard{}
	}

	// Apply custom ordering if available
	if accountID > 0 {
		// Apply order to Taipei dashboards
		taipeiCity := "taipei"
		taipeiOrder, _ := GetDashboardOrderByCity(accountID, &taipeiCity)
		if taipeiOrder != nil && len(taipeiOrder.DashboardIndexes) > 0 {
			dashboards.Taipei = applyDashboardOrder(dashboards.Taipei, taipeiOrder.DashboardIndexes)
		}

		// Apply order to MetroTaipei dashboards
		metroCity := "metrotaipei"
		metroOrder, _ := GetDashboardOrderByCity(accountID, &metroCity)
		if metroOrder != nil && len(metroOrder.DashboardIndexes) > 0 {
			dashboards.MetroTaipei = applyDashboardOrder(dashboards.MetroTaipei, metroOrder.DashboardIndexes)
		}

		// Apply order to Personal dashboards
		personalOrder, _ := GetDashboardOrderByCity(accountID, nil)

		if personalOrder != nil && len(personalOrder.DashboardIndexes) > 0 {
			// For personal dashboards, keep the favorite dashboard at the top
			favorite := findFavoriteDashboard(dashboards.Personal)
			nonFavorites := filterOutFavoriteDashboard(dashboards.Personal)

			// Apply order to non-favorites
			orderedNonFavorites := applyDashboardOrder(nonFavorites, personalOrder.DashboardIndexes)

			// Combine back with favorite at the top
			if favorite != nil {
				dashboards.Personal = append([]Dashboard{*favorite}, orderedNonFavorites...)
			} else {
				dashboards.Personal = orderedNonFavorites
			}
		}
	}
	return dashboards, err
}

// Helper functions for dashboard ordering

// findFavoriteDashboard finds and returns the favorite dashboard
func findFavoriteDashboard(dashboards []Dashboard) *Dashboard {
	for i, d := range dashboards {
		if d.Icon == "favorite" {
			return &dashboards[i]
		}
	}
	return nil
}

// filterOutFavoriteDashboard returns all dashboards except the favorite one
func filterOutFavoriteDashboard(dashboards []Dashboard) []Dashboard {
	var result []Dashboard
	for _, d := range dashboards {
		if d.Icon != "favorite" {
			result = append(result, d)
		}
	}
	return result
}

// GetDashboardOrderByCity retrieves the dashboard order for a specific user and city
func GetDashboardOrderByCity(userID int, city *string) (*DashboardOrder, error) {
	var order DashboardOrder
	var dashboardIndexesJSON []byte
	var query string
	var args []interface{}

	// Fix the nil pointer dereference by checking if city is nil before logging
	if city != nil {
		logs.FDebug("Executing query for dashboard order by city: %s, userID: %d", *city, userID)
	} else {
		logs.FDebug("Executing query for personal dashboard order, userID: %d", userID)
	}

	if city != nil {
		query = `
			SELECT id, user_id, city, dashboard_indexes, _ctime, _mtime
			FROM dashboard_order
			WHERE user_id = $1 AND city = $2
		`
		args = []interface{}{userID, *city}
	} else {
		query = `
			SELECT id, user_id, city, dashboard_indexes, _ctime, _mtime
			FROM dashboard_order
			WHERE user_id = $1 AND city = ''
		`
		args = []interface{}{userID}
	}

	err := DBManager.Raw(query, args...).Row().Scan(
		&order.ID,
		&order.UserID,
		&order.City,
		&dashboardIndexesJSON,
		&order.CreatedAt,
		&order.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No order exists, return nil without error
		}
		return nil, err
	}

	// Parse dashboard indexes from JSON
	err = json.Unmarshal(dashboardIndexesJSON, &order.DashboardIndexes)
	if err != nil {
		return nil, err
	}

	return &order, nil
}

// applyDashboardOrder reorders dashboards based on the saved order
func applyDashboardOrder(dashboards []Dashboard, orderIndexes []string) []Dashboard {
	if len(dashboards) == 0 || len(orderIndexes) == 0 {
		return dashboards
	}

	// Create a map for quick lookup
	dashboardMap := make(map[string]Dashboard)
	for _, dashboard := range dashboards {
		dashboardMap[dashboard.Index] = dashboard
	}

	// Create an ordered result based on the orderIndexes
	var result []Dashboard

	// First add items in the specified order
	for _, index := range orderIndexes {
		if dashboard, exists := dashboardMap[index]; exists {
			result = append(result, dashboard)
			delete(dashboardMap, index) // Remove to avoid duplicates
		}
	}

	// Then add any remaining items
	for _, dashboard := range dashboardMap {
		result = append(result, dashboard)
	}

	return result
}

func GetAllPublicGroupsID() (ids []int, err error) {
	// Assume is_personal = false means public group
	err = DBManager.
		Table("groups").
		Where("is_personal = false").
		Pluck("groups.id", &ids).
		Error

	if err != nil {
		return ids, err
	}

	return ids, err
}

func GetDashboardByIndex(index string, groups []int, city string) (components []CityComponent, err error) {
	tempDB := createTempComponentDB()

	type componentArray struct {
		Components pq.Int64Array `gorm:"type:int[]"`
	}
	var componentIds componentArray

	// 1. Make sure the dashboard exists
	err = DBManager.Table("dashboards").Select("components").Where("index = ?", index).First(&componentIds).Error
	if err != nil {
		return components, err
	}

	// 2. Make sure the user has access to the dashboard
	err = DBManager.
		Table("dashboards").Select("components").
		Joins("JOIN dashboard_groups ON dashboards.id = dashboard_groups.dashboard_id AND dashboard_groups.group_id IN (?)", groups).
		Where("index = ?", index).
		Order("dashboards.id").
		First(&componentIds).
		Error
	if err != nil {
		return components, err
	}

	// 3. Format component ids into slice and string
	var componentIdsSlice []int64
	for _, v := range componentIds.Components {
		componentIdsSlice = append(componentIdsSlice, int64(v))
	}

	if len(componentIdsSlice) == 0 {
		return components, err
	}

	var componentIdsString string
	for i, v := range componentIdsSlice {
		if i > 0 {
			componentIdsString += ","
		}
		componentIdsString += fmt.Sprintf("%d", v)
	}

	// 4. Get components by ids
	query := tempDB.
		Where(componentIdsSlice).
		Order(fmt.Sprintf("ARRAY_POSITION(ARRAY[%s], components.id)", componentIdsString))
	if (city != "") {
		query = query.Where("query_charts.city = ?", city)
	}
	err = query.Find(&components).Error

	// Add ComponentMap City field for front-end display purpose
	type ComponentMap struct {
		ID       int64            `json:"id" gorm:"column:id;autoincrement;primaryKey"`
		City     string           `json:"city"       gorm:"column:index;type:varchar;not null"`
		Index    string           `json:"index"      gorm:"column:index;type:varchar;not null"`
		Title    string           `json:"title"      gorm:"column:title;type:varchar;not null"`
		Type     string           `json:"type"       gorm:"column:type;type:varchar;not null"`
		Source   string           `json:"source"     gorm:"column:source;type:varchar;not null"`
		Size     *string          `json:"size"       gorm:"column:size;type:varchar"`
		Icon     *string          `json:"icon"       gorm:"column:icon;type:varchar"`
		Paint    *json.RawMessage `json:"paint" gorm:"column:paint;type:json"`
		Property *json.RawMessage `json:"property" gorm:"column:property;type:json"`
	}

	for k, v := range components {
		var maps []ComponentMap
		filteredMaps := make([]ComponentMap, 0)
		if err := json.Unmarshal(v.MapConfig, &maps); err != nil {
			return components, err
		}

		for kk, vv := range maps {
			maps[kk].City = v.City
			if vv.ID != 0 {
				filteredMaps = append(filteredMaps, maps[kk])
			}
		}

		maps = filteredMaps
		jsonMaps, _ := json.Marshal(maps)
		components[k].MapConfig = jsonMaps
	}
	return components, err
}

func CheckDashboardIndex(index string) (bool, error) {
	var count int64
	err := DBManager.Table("dashboards").Where("index = ?", index).Count(&count).Error
	return count < 1, err
}

func CreateDashboard(index, name, icon string, components pq.Int64Array, belongGroup int) (dashboard Dashboard, err error) {
	dashboard = Dashboard{
		Index:      index,
		Name:       name,
		Icon:       icon,
		Components: components,
		CreatedAt:  time.Now(),
		UpdatedAt:  time.Now(),
	}

	tx := DBManager.Begin()

	// Create the dashboard
	if err := tx.Create(&dashboard).Error; err != nil {
		tx.Rollback()
		return Dashboard{}, err
	}

	// Create a new dashboard group
	dashboardGroup := DashboardGroup{
		DashboardID: dashboard.ID,
		GroupID:     belongGroup,
	}

	if err := tx.Create(&dashboardGroup).Error; err != nil {
		tx.Rollback()
		// If an error occurs while creating the dashboard group, delete the dashboard to maintain consistency.
		if deleteErr := tx.Delete(&dashboard).Error; deleteErr != nil {
			// If deletion fails, log the error.
			logs.FError("Failed to delete dashboard after failed group creation: %v", deleteErr)
		}
		return Dashboard{}, err
	}

	tx.Commit()
	return dashboard, nil
}

func UpdateDashboard(index string, name, icon string, components pq.Int64Array, groups []int) (dashboard Dashboard, err error) {
	tx := DBManager.Begin()

	// Check if the dashboard exists
	if err = tx.Where("index = ?", index).First(&dashboard).Error; err != nil {
		tx.Rollback()
		return dashboard, err
	}
	// Check if the user has edit access to the dashboard
	err = DBManager.
		Table("dashboards").
		Joins("JOIN dashboard_groups ON dashboards.id = dashboard_groups.dashboard_id AND dashboard_groups.group_id IN (?)", groups).
		Where("index = ?", index).
		First(&dashboard).
		Error
	if err != nil {
		tx.Rollback()
		return dashboard, err
	}

	dashboard.Name = name
	dashboard.Icon = icon
	dashboard.Components = components
	dashboard.UpdatedAt = time.Now()

	// Save the updated dashboard
	if err := tx.Table("dashboards").Where("index = ?", index).Updates(&dashboard).Error; err != nil {
		tx.Rollback()
		return dashboard, err
	}

	if err := tx.Table("dashboards").Where("index = ?", index).Find(&dashboard).Error; err != nil {
		return dashboard, err
	}

	tx.Commit()
	return dashboard, nil
}

func DeleteDashboard(userID int, index string, groups []int) (err error) {
	tx := DBManager.Begin()

	var dashboard Dashboard
	var dashboardGroup DashboardGroup
	var deleteDashboard DashboardGroup

	// Check if the dashboard exists
	if err := tx.Where("index = ?", index).First(&dashboard).Error; err != nil {
		tx.Rollback()
		return err
	}
	// Check if the user has edit access to the dashboard
	err = DBManager.
		Select("dashboard_groups.group_id").
		Joins("JOIN dashboards ON dashboard_groups.dashboard_id = dashboards.id AND dashboard_groups.group_id IN (?)", groups).
		Where("index = ?", index).
		First(&deleteDashboard).
		Error
	if err != nil {
		return err
	}

	// Remove the dashboard from all possible dashboard orders
	if userID > 0 {
		cities := []string{"", "taipei", "metrotaipei"}
		for _, city := range cities {
			cityPtr := &city
			RemoveDashboardFromOrders(userID, index, cityPtr)
		}
	}

	// Delete the dashboard group
	if err := DBManager.Table("dashboard_groups").Where("dashboard_id = ?", dashboard.ID).Delete(&dashboardGroup).Error; err != nil {
		tx.Rollback()
		return err
	}
	// Delete the dashboard
	if err := tx.Delete(&dashboard).Error; err != nil {
		tx.Rollback()
		return err
	}

	tx.Commit()
	return nil
}

// RemoveDashboardFromOrders removes a dashboard from any order records
func RemoveDashboardFromOrders(userID int, index string, city *string) error {
	// Find the order record for this city/user combination
	var order DashboardOrder
	var dashboardIndexesJSON []byte
	var query string
	var args []interface{}

	// Fix the nil pointer dereference by checking if city is nil before logging
	if city != nil {
		logs.FDebug("Executing query for dashboard order by city: %s, userID: %d", *city, userID)
	} else {
		logs.FDebug("Executing query for personal dashboard order, userID: %d", userID)
	}

	if city != nil {
		query = `
			SELECT id, user_id, city, dashboard_indexes, _ctime, _mtime
			FROM dashboard_order
			WHERE user_id = $1 AND city = $2
		`
		args = []interface{}{userID, *city}
	} else {
		query = `
			SELECT id, user_id, city, dashboard_indexes, _ctime, _mtime
			FROM dashboard_order
			WHERE user_id = $1 AND city = ''
		`
		args = []interface{}{userID}
	}

	err := DBManager.Raw(query, args...).Row().Scan(
		&order.ID,
		&order.UserID,
		&order.City,
		&dashboardIndexesJSON,
		&order.CreatedAt,
		&order.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil // No order exists, nothing to update
		}
		return err
	}

	// Parse dashboard indexes from JSON
	var dashboardIndexes []string
	if err := json.Unmarshal(dashboardIndexesJSON, &dashboardIndexes); err != nil {
		return err
	}

	// Filter out the deleted index
	var newDashboardIndexes []string
	for _, idx := range dashboardIndexes {
		if idx != index {
			newDashboardIndexes = append(newDashboardIndexes, idx)
		}
	}

	// If no changes, return early
	if len(newDashboardIndexes) == len(dashboardIndexes) {
		return nil
	}

	// Update the order
	newJSON, err := json.Marshal(newDashboardIndexes)
	if err != nil {
		return err
	}

	updateQuery := `
		UPDATE dashboard_order
		SET dashboard_indexes = $1,
			_mtime = CURRENT_TIMESTAMP
		WHERE id = $2
	`
	return DBManager.Exec(updateQuery, newJSON, order.ID).Error
}
