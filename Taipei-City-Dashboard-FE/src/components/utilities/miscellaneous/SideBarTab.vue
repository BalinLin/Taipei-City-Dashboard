<!-- Developed by Taipei Urban Intelligence Center 2023-2024-->

<!-- This component has two modes "expanded" and "collapsed" which is controlled by the prop "expanded" -->

<script setup>
import { computed, ref } from "vue";
import { useRoute } from "vue-router";
import { useAuthStore } from "../../../store/authStore";

const route = useRoute();
const isDragOver = ref(false);

const props = defineProps({
	icon: { type: String },
	title: { type: String },
	index: { type: String },
	city: { type: String },
	expanded: { type: Boolean },
	draggable: { type: Boolean, default: false },
});

const emit = defineEmits(['dragstart', 'dragover', 'drop', 'dragend']);

const authStore = useAuthStore();

const tabLink = computed(() => {
	const isAdminPath = authStore.currentPath === "admin";
	const cityParam = props.city ? `${isAdminPath ? "?" : "&"}city=${props.city}` : "";
	return isAdminPath
		? `/admin/${props.index}${cityParam}`
		: `${route.path}?index=${props.index}${cityParam}`;
});

const linkActiveOrNot = computed(() => {
	const isAdminPath = authStore.currentPath === "admin";
	const isPathMatch = isAdminPath
		? route.path === `/admin/${props.index}`
		: route.query.index === props.index;
	const isCityMatch = props.city
		? route.query.city === props.city
		: true;

	return isPathMatch && isCityMatch;
});

const handleDragStart = (e) => {
	if (!props.draggable) return;
	e.dataTransfer.dropEffect = 'move';
	e.dataTransfer.effectAllowed = 'move';
	e.dataTransfer.setData('text/plain', JSON.stringify({
		index: props.index,
		city: props.city
	}));
	e.currentTarget.classList.add('dragging');
	emit('dragstart', { index: props.index, city: props.city });
};

const handleDragOver = (e) => {
	if (!props.draggable) return;
	e.preventDefault();
	isDragOver.value = true;
	emit('dragover', { index: props.index, city: props.city, event: e });
};

const handleDragLeave = () => {
	if (!props.draggable) return;
	isDragOver.value = false;
};

const handleDrop = (e) => {
	if (!props.draggable) return;
	e.preventDefault();
	isDragOver.value = false;
	const data = JSON.parse(e.dataTransfer.getData('text/plain'));
	emit('drop', {
		sourceIndex: data.index,
		sourceCity: data.city,
		targetIndex: props.index,
		targetCity: props.city
	});
};

const handleDragEnd = (e) => {
	if (!props.draggable) return;
	e.currentTarget.classList.remove('dragging');
	isDragOver.value = false;
	emit('dragend');
};
</script>

<template>
  <router-link
    :to="tabLink"
    :class="{
      sidebartab: true,
      'sidebartab-active': linkActiveOrNot,
      'sidebartab-draggable': draggable,
      'sidebartab-dragover': isDragOver
    }"
    :draggable="draggable"
    @dragstart="handleDragStart"
    @dragover="handleDragOver"
    @dragleave="handleDragLeave"
    @drop="handleDrop"
    @dragend="handleDragEnd"
  >
    <span :title="!expanded ? title : ''">{{ icon }}</span>
    <h3 v-if="expanded">
      {{ title }}
    </h3>
  </router-link>
</template>

<style scoped lang="scss">
.sidebartab {
	max-height: var(--font-xl);
	display: flex;
	align-items: center;
	margin: var(--font-s) 0;
	border-left: solid 4px transparent;
	border-radius: 0 5px 5px 0;
	transition: background-color 0.2s;
	white-space: nowrap;
	text-wrap: nowrap;

	&:hover {
		background-color: var(--color-component-background);
	}

	span {
		min-width: var(--font-l);
		margin-left: var(--font-s);
		font-family: var(--font-icon);
		font-size: calc(var(--font-m) * var(--font-to-icon));
	}

	h3 {
		margin-left: var(--font-s);
		font-size: var(--font-m);
		font-weight: 400;
	}

	&-active {
		border-left-color: var(--color-highlight);
		background-color: var(--color-component-background);

		span,
		h3 {
			color: var(--color-highlight);
		}
	}

	&-draggable {
		cursor: grab;

		&.dragging {
			opacity: 0.5;
			cursor: grabbing;
		}
	}

	&-dragover {
		background-color: var(--color-highlight-light, #4f99d633);
		border: 1px dashed var(--color-highlight, #4f99d6);
		transform: scale(1.02);
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	}
}
</style>
