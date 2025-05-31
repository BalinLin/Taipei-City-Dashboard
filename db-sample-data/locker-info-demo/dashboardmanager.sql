INSERT INTO public.components (id, index, name)
VALUES (301, 'locker_info', '置物櫃資訊');

INSERT INTO public.component_charts (index, color, types, unit) VALUES ('locker_info', '{#eb546d,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}', '{BarPercentChart}', '櫃');

INSERT INTO public.component_maps (id, index, title, type, source, size, icon, paint, property) VALUES (301, 'locker_info_metrotaipei', '置物櫃資訊', 'circle', 'geojson', null, null, e'{
  "circle-color": [
    "case",
    [">", ["/", ["get", "置物櫃空位"], ["get", "置物櫃數量"]], 0.7], "#4CAF50",
    [">", ["/", ["get", "置物櫃空位"], ["get", "置物櫃數量"]], 0.4], "#FFC107",
    "#F44336"
  ],
  "circle-radius": [
    "case",
    ["<", ["get", "置物櫃數量"], 10], 2,
    ["<", ["get", "置物櫃數量"], 20], 3,
    ["<", ["get", "置物櫃數量"], 30], 4,
    5
  ]
}', '[{"key":"置物櫃空位","name":"置物櫃空位"},{"key":"置物櫃數量","name":"置物櫃數量"},{"key":"地點名稱","name":"地點名稱"}]');
INSERT INTO public.component_maps (id, index, title, type, source, size, icon, paint, property) VALUES (300, 'locker_info_taipei', '置物櫃資訊', 'circle', 'geojson', null, null, e'{
  "circle-color": [
    "case",
    [">", ["/", ["get", "置物櫃空位"], ["get", "置物櫃數量"]], 0.7], "#4CAF50",
    [">", ["/", ["get", "置物櫃空位"], ["get", "置物櫃數量"]], 0.4], "#FFC107",
    "#F44336"
  ],
  "circle-radius": [
    "case",
    ["<", ["get", "置物櫃數量"], 10], 2,
    ["<", ["get", "置物櫃數量"], 20], 3,
    ["<", ["get", "置物櫃數量"], 30], 4,
    5
  ]
}', '[{"key":"置物櫃空位","name":"置物櫃空位"},{"key":"置物櫃數量","name":"置物櫃數量"},{"key":"地點名稱","name":"地點名稱"}]');


INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city) VALUES ('locker_info', 'null', '{301}', 'null', 'static', null, null, null, '捷運公司', '捷運置物櫃資訊', '提供捷運站的置物櫃空閒度', '透過置物櫃佔用量可以間接了解外來遊客到達該捷運商圈的擁擠度', '{https://data.taipei/dataset/detail?id=53d78a0d-a59a-4d3d-a31e-a1cc99864d7c,https://data.taipei/dataset/detail?id=cfa4778c-62c1-497b-b704-756231de348b}', '{doit}', '2025-05-28 16:03:28.350000 +00:00', '2025-05-29 10:27:21.710038 +00:00', 'percent', e'SELECT
    x_axis, y_axis, data
FROM (SELECT "行政區"                                                          AS "x_axis",
             \'空櫃\'                                                            AS "y_axis",
             SUM("置物櫃空位")                                                   AS "data",
             ROUND(SUM("置物櫃空位")::NUMERIC / NULLIF(SUM("置物櫃數量"), 0), 4) AS "空櫃比例"
      FROM "locker_info_metro_taipei"
      GROUP BY "行政區"

      UNION ALL

      SELECT "行政區"                                                          AS "x_axis",
             \'已使用\'                                                          AS "y_axis",
             SUM("置物櫃數量" - "置物櫃空位")                                    AS "data",
             ROUND(SUM("置物櫃空位")::NUMERIC / NULLIF(SUM("置物櫃數量"), 0), 4) AS "空櫃比例"
      FROM "locker_info_metro_taipei"
      GROUP BY "行政區"
      ORDER BY "空櫃比例", "x_axis", "y_axis")
', null, 'metrotaipei');
INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city) VALUES ('locker_info', 'null', '{300}', 'null', 'static', null, null, null, '捷運公司', '捷運置物櫃資訊', '提供捷運站的置物櫃空閒度', '透過置物櫃佔用量可以間接了解外來遊客到達該捷運商圈的擁擠度', '{https://data.taipei/dataset/detail?id=53d78a0d-a59a-4d3d-a31e-a1cc99864d7c,https://data.taipei/dataset/detail?id=cfa4778c-62c1-497b-b704-756231de348b}', '{doit}', '2025-05-28 16:03:28.350000 +00:00', '2025-05-29 10:27:21.710038 +00:00', 'percent', e'SELECT
    x_axis, y_axis, data
FROM (SELECT "行政區"                                                          AS "x_axis",
             \'空櫃\'                                                            AS "y_axis",
             SUM("置物櫃空位")                                                   AS "data",
             ROUND(SUM("置物櫃空位")::NUMERIC / NULLIF(SUM("置物櫃數量"), 0), 4) AS "空櫃比例"
      FROM "locker_info_metro_taipei"
      WHERE "縣市" = \'臺北市\'
      GROUP BY "行政區"

      UNION ALL

      SELECT "行政區"                                                          AS "x_axis",
             \'已使用\'                                                          AS "y_axis",
             SUM("置物櫃數量" - "置物櫃空位")                                    AS "data",
             ROUND(SUM("置物櫃空位")::NUMERIC / NULLIF(SUM("置物櫃數量"), 0), 4) AS "空櫃比例"
      FROM "locker_info_metro_taipei"
      WHERE "縣市" = \'臺北市\'
      GROUP BY "行政區"
      ORDER BY "空櫃比例", "x_axis", "y_axis")
', null, 'taipei');
