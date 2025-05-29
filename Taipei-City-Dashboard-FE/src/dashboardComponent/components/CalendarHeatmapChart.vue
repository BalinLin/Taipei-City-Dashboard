<!-- Developed by Taipei Urban Intelligence Center 2023-2024-->

<script setup>
import { ref, computed } from "vue";
// import { MapConfig, MapFilter } from "../utilities/componentConfig";
import VueApexCharts from "vue3-apexcharts";

const props = defineProps(["chart_config", "activeChart", "series"]);

// 下拉選單選項與狀態
const availablePeriods = ref([]); // 例如 ["2024H1", "2024H2", "2025H1"]
const selectedPeriod = ref("");
const availableNames = ref([]); // 例如 ["人數1", "人數2"]
const selectedName = ref("");

// 依據 props.series 產生可用的期間與人名
function getHalfYear(dateStr) {
	const date = new Date(dateStr);
	const year = date.getFullYear();
	const month = date.getMonth() + 1;
	if (month <= 6) return `${year}H1`;
	return `${year}H2`;
}

// 根據 props.series 更新下拉選單選項
function updateDropdownOptions() {
	// 清空目前的選項
	const periods = new Set();
	const names = [];

	// 迭過所有 series，收集期間與名稱
	props.series.forEach((s) => {
		names.push(s.name);
		s.data.forEach((d) => {
			periods.add(getHalfYear(d.x));
		});
	});

	// 依照年份與 H1/H2 排序，最近的在最上面
	availablePeriods.value = Array.from(periods).sort((a, b) => {
		const [ay] = a.split("H");
		const [by] = b.split("H");
		if (ay !== by) return by - ay;
		// H2 比 H1 新
		return b.endsWith("H2") ? 1 : -1;
	});
	availableNames.value = names;
	// 預設選取最近的年份

	if (availablePeriods.value.length > 0) {
		selectedPeriod.value = availablePeriods.value[0];
	}
	if (!selectedName.value && availableNames.value.length > 0) {
		selectedName.value = availableNames.value[0];
	}
}

// 根據 props.series 過濾出目前選擇的 series 資料
const filteredSeries = computed(() => {
	const target = props.series.find((s) => s.name === selectedName.value);
	if (!target) return [{ name: selectedName.value, data: [] }];
	const period = selectedPeriod.value;
	// 取得該半年度的所有資料
	let filteredData = target.data.filter((d) => getHalfYear(d.x) === period);
	// 取得該半年度的第一天
	let year = parseInt(period.slice(0, 4));
	let half = period.endsWith("H1") ? 1 : 2;
	let startMonth = half === 1 ? 0 : 6;
	let startDay = new Date(year, startMonth, 1);
	// 取得前7天的資料（跨年處理）
	let before7 = new Date(startDay);
	before7.setDate(startDay.getDate() - 7);
	const extraData = target.data.filter((d) => {
		const date = new Date(d.x);
		return date >= before7 && date < startDay;
	});
	filteredData = [...extraData, ...filteredData];
	return [{ name: target.name, data: filteredData }];
});

// 根據 filteredSeries 生成顏色範圍
const colorScale = computed(() => {
	const maxValue = filteredSeries.value[0]?.data?.reduce(
		(max, item) => Math.max(max, typeof item.y === 'number' ? item.y : 0),
		0
	);
	const ranges = props.chart_config.color.map((el, index) => ({
		to: Math.floor(
			(maxValue / props.chart_config.color.length) *
			(props.chart_config.color.length - index)
		),
		from:
			Math.floor(
				(maxValue / props.chart_config.color.length) *
				(props.chart_config.color.length - index - 1)
			) + 1,
		color: el,
	}));
	ranges.unshift({
		to: 0,
		from: 0,
		color: "#444444",
	});
	return ranges;
});

// 根據 filteredSeries 生成半年的 heatmap 資料
const halfYearSeries = computed(() => {
	// 依據 filteredSeries 產生 heatmap 資料
	let series = [
		{ name: "Sun", data: [] },
		{ name: "Mon", data: [] },
		{ name: "Tue", data: [] },
		{ name: "Wed", data: [] },
		{ name: "Thu", data: [] },
		{ name: "Fri", data: [] },
		{ name: "Sat", data: [] },
	];

	// 以下拉選單選到的半年度來建立 Calender
	const period = selectedPeriod.value;
	const year = parseInt(period.slice(0, 4));
	const half = period.endsWith("H1") ? 1 : 2;
	let startMonth, endMonth;
	if (half === 1) {
		startMonth = 0; // 1月
		endMonth = 5; // 6月
	} else {
		startMonth = 6; // 7月
		endMonth = 11; // 12月
	}
	const startDay = new Date(year, startMonth, 1);
	const endDay = new Date(year, endMonth + 1, 0);
	let calendarStart;
	if (half === 1) {
		calendarStart = new Date(startDay);
		calendarStart.setDate(startDay.getDate() - startDay.getDay());
	} else {
		calendarStart = new Date(year, 6, 1);
		calendarStart.setDate(1 - calendarStart.getDay());
	}
	let calendarEnd = new Date(endDay);
	calendarEnd.setDate(endDay.getDate() + (6 - endDay.getDay()));
	const days =
		Math.floor((calendarEnd - calendarStart) / (24 * 60 * 60 * 1000)) + 1;

	// 初始化每個星期的資料
	for (let i = 0; i < days; i++) {
		const date = new Date(calendarStart);
		date.setDate(calendarStart.getDate() + i);
		const weekday = date.getDay();
		series[weekday].data.push({
			x: `${date.getMonth() + 1}/${date.getDate()}`,
			y: 0,
		});
	}

	// 將 filteredSeries 中的資料填入對應的 weekday
	for (const item of filteredSeries.value[0].data) {
		const date = new Date(item.x);
		const weekday = date.getDay();
		const yValue = item.y || 0;
		const daysSinceStart = Math.floor(
			(date - calendarStart) / (24 * 60 * 60 * 1000)
		);
		const weekNumber = Math.floor(daysSinceStart / 7);
		if (series[weekday].data[weekNumber]) {
			series[weekday].data[weekNumber].y += yValue;
		}
	}
	return series.reverse();
});

// 將 chartOptions 為 computed，colorScale.ranges 可以動態更新
const chartOptions = computed(() => ({
	chart: {
		toolbar: {
			show: false,
		},
		width: '100%',
		height: '150px',
	},
	dataLabels: {
		enabled: false,
	},
	legend: {
		show: false,
	},
	grid: {
		show: false,
	},
	stroke: {
		show: true,
		width: 2,
		colors: ["#282a2c"],
	},
	xaxis: {
		axisBorder: {
			show: false,
		},
		axisTicks: {
			show: false,
		},
		categories: props.chart_config.categories
			? props.chart_config.categories
			: [],
		labels: {
			offsetY: -5,
			formatter: function (value, v, w) {
				if (w && w.i % 4 == 0) {
					return value.length > 7 ? value.slice(0, 6) + "..." : value;
				} else {
					return "";
				}
			},
		},
		tooltip: {
			enabled: false,
		},
		type: "category",
	},
	plotOptions: {
		heatmap: {
			enableShades: false,
			radius: 2,
			colorScale: {
				ranges: colorScale.value,
			},
		},
	},
	tooltip: {
		custom: function ({ series, seriesIndex, dataPointIndex, w }) {
			return (
				'<div class="chart-tooltip">' +
				"<h6>" +
				w.globals.seriesX[seriesIndex][dataPointIndex] +
				" " +
				w.globals.seriesNames[seriesIndex] +
				"</h6>" +
				"<span>" +
				series[seriesIndex][dataPointIndex] +
				` ${props.chart_config.unit}` +
				"</span>" +
				"</div>"
			);
		},
	},
}));

updateDropdownOptions();
</script>

<template>
  <div
    v-if="activeChart === 'CalendarHeatmapChart'"
    class="heatmapchart"
  >
    <div>
      <select
        v-model="selectedPeriod"
        name="label"
        class="selectBtn"
      >
        <option
          v-for="period in availablePeriods"
          :key="period"
          :value="period"
        >
          {{ period }}
        </option>
      </select>
      <span class="select-gap" />
      <select
        v-model="selectedName"
        name="city"
        class="selectBtn"
      >
        <option
          v-for="name in availableNames"
          :key="name"
          :value="name"
        >
          {{ name }}
        </option>
      </select>
    </div>
    <VueApexCharts
      width="100%"
      height="150px"
      type="heatmap"
      class="chart222"
      :options="chartOptions"
      :series="halfYearSeries"
    />
  </div>
</template>

<style scoped>
.select-gap {
	display: inline-block;
	width: 16px;
}
</style>
