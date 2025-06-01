<!-- Developed by Taipei Urban Intelligence Center 2023-2024-->

<!-- Adding new components and settings is disabled in public dashboards and the mobile version -->

<script setup>
import { computed, ref } from "vue";
import { useRoute } from "vue-router";
import { useAuthStore } from "../../../store/authStore";
import { useContentStore } from "../../../store/contentStore";
import { useDialogStore } from "../../../store/dialogStore";
import { useMapStore } from "../../../store/mapStore";

import AddEditDashboards from "../../dialogs/AddEditDashboards.vue";
import MobileNavigation from "../../dialogs/MobileNavigation.vue";
import AddViewPoint from "../../dialogs/AddViewPoint.vue";

const contentStore = useContentStore();
const dialogStore = useDialogStore();
const mapStore = useMapStore();
const authStore = useAuthStore();
const route = useRoute();

const isCurrentPageMapView = computed(() => route.name === "mapview");
const clusteringEnabled = ref(mapStore.clusteringEnabled);

function handleOpenSettings() {
	contentStore.editDashboard = JSON.parse(
		JSON.stringify(contentStore.currentDashboard)
	);
	dialogStore.addEdit = "edit";
	dialogStore.showDialog("addEditDashboards");
}

function toggleClustering() {
  mapStore.toggleClustering(!mapStore.clusteringEnabled);
  clusteringEnabled.value = mapStore.clusteringEnabled;
}
</script>

<template>
  <div class="settingsbar">
    <div class="settingsbar-title">
      <span>{{ contentStore.currentDashboard.icon }}</span>
      <h2>{{ contentStore.currentDashboard.name }}</h2>
      <button
        class="show-if-mobile"
        @click="dialogStore.showDialog('mobileNavigation')"
      >
        <span class="settingsbar-title-navigation">arrow_drop_down_circle</span>
      </button>
      <MobileNavigation />
      <div
        v-if="
          contentStore.personalDashboards
            .map((el) => el.index)
            .includes(contentStore.currentDashboard.index) &&
            contentStore.currentDashboard.icon !== 'favorite'
        "
        class="settingsbar-settings hide-if-mobile"
      >
        <button @click="handleOpenSettings">
          <span>settings</span>
          <p>設定</p>
        </button>
      </div>
      <AddEditDashboards />
    </div>
    <div v-if="authStore.user?.user_id && isCurrentPageMapView" class="settingsbar-controls hide-if-mobile">
      <div class="settingsbar-clustering">
        <span>群聚</span>
        <label class="switch">
          <input type="checkbox" v-model="clusteringEnabled" @change="toggleClustering">
          <span class="slider round"></span>
        </label>
      </div>
      <button
        class="settingsbar-pin"
        :disabled="!mapStore.tempMarkerCoordinates"
        :style="{
          opacity: !mapStore.tempMarkerCoordinates ? 0.5 : 1,
          cursor: !mapStore.tempMarkerCoordinates
            ? 'not-allowed'
            : 'pointer',
        }"
        @click="dialogStore.showDialog('addPin')"
      >
        {{ mapStore.tempMarkerCoordinates ? "新增地標" : "雙擊以建立地標" }}
      </button>
    </div>
  </div>
  <AddViewPoint name="addPin" />
</template>

<style scoped lang="scss">
.settingsbar {
	width: calc(100% - 2 * var(--font-m));
	min-height: 1.6rem;
	display: flex;
	justify-content: space-between;
	margin: 20px var(--font-m) 0;
	padding-bottom: 0.5rem;
	border-bottom: solid 1px var(--color-border);
	user-select: none;

	&-title {
		display: flex;
		align-items: center;
		overflow: hidden;

		span {
			font-family: var(--font-icon);
			font-size: calc(var(--font-m) * var(--font-to-icon));
		}

		h2 {
			margin: 0 var(--font-s);
			font-weight: 400;
			font-size: var(--font-m);
			white-space: nowrap;
		}

		&-navigation {
			margin-left: 4px;
			color: var(--color-complement-text);
		}
	}

	&-settings {
		display: flex;
		align-items: center;

		span {
			margin-right: 4px;
			font-family: var(--font-icon);
			font-size: calc(var(--font-m) * var(--font-to-icon));
		}

		button {
			display: flex;
			align-items: center;
			border-radius: 5px;
			margin-left: 4px;

			p {
				width: 0px;
				max-height: 1.2rem;
				font-size: 0.8rem;
				text-align: left;
				transition: width 0.2s, color 0.2s;
				overflow-x: hidden;
			}

			&:hover p {
				width: 55px;
				color: var(--color-highlight);
			}

			span {
				color: var(--color-complement-text);
				transition: color 0.2s;
			}

			&:hover span {
				color: var(--color-highlight);
			}
		}
	}

	&-controls {
		display: flex;
		align-items: center;
		gap: 15px;
	}

	&-clustering {
		display: flex;
		align-items: center;
		gap: 8px;

		span {
			font-size: 0.9rem;
		}
	}

	&-pin {
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 2px 4px;
		border-radius: 4px;
		background-color: var(--color-highlight);
	}

	/* Toggle Switch Styles */
	.switch {
		position: relative;
		display: inline-block;
		width: 36px;
		height: 20px;
	}

	.switch input {
		opacity: 0;
		width: 0;
		height: 0;
	}

	.slider {
		position: absolute;
		cursor: pointer;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background-color: #ccc;
		transition: .3s;
	}

	.slider:before {
		position: absolute;
		content: "";
		height: 16px;
		width: 16px;
		left: 2px;
		bottom: 2px;
		background-color: white;
		transition: .3s;
	}

	input:checked + .slider {
		background-color: var(--color-highlight);
	}

	input:focus + .slider {
		box-shadow: 0 0 1px var(--color-highlight);
	}

	input:checked + .slider:before {
		transform: translateX(16px);
	}

	.slider.round {
		border-radius: 34px;
	}

	.slider.round:before {
		border-radius: 50%;
	}
}
</style>
