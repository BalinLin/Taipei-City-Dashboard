<script setup>
import { ref, computed } from "vue";
import VueApexCharts from "vue3-apexcharts";

const props = defineProps([
	"chart_config",
	"activeChart",
	"series",
	"map_config",
	"map_filter",
	"map_filter_on",
]);

const formattedSeries = computed(() => [
	{
		data: props.chart_config.categories.map((category, index) => ({
			x: category,
			y: [
				props.series[0].data[index], // min
				props.series[1].data[index], // q1
				props.series[2].data[index], // median
				props.series[3].data[index], // q3
				props.series[4].data[index], // max
			],
		})),
	},
]);

const chartOptions = ref({
	chart: {
		type: "boxPlot",
		toolbar: {
			show: false,
		},
	},
	plotOptions: {
		boxPlot: {
			colors: {
				upper: [...props.chart_config.color][0],
				lower: [...props.chart_config.color][1],
			},
		},
	},
	xaxis: {
		type: "category",
		tooltip: {
			enabled: false,
		},
		categories: props.chart_config.categories
			? props.chart_config.categories
			: [],
	},
	tooltip: {
		shared: false,
		intersect: true,
		custom: function ({ seriesIndex, dataPointIndex, w }) {
			const val = w.config.series[seriesIndex].data[dataPointIndex];
			return `
                <div class="chart-tooltip">
                    <h6>${val.x}</h6>
                    <span>最小值: ${val.y[0]}</span><br/>
                    <span>Q1: ${val.y[1]}</span><br/>
                    <span>中位數: ${val.y[2]}</span><br/>
                    <span>Q3: ${val.y[3]}</span><br/>
                    <span>最大值: ${val.y[4]}</span>
                </div>
            `;
		},
	},
	stroke: {
		colors: [[...props.chart_config.color][2]],
		width: 1,
	},
	grid: {
		show: true,
		borderColor: "#FFFFFF",
	},
});
</script>

<template>
  <div
    v-if="activeChart === 'BoxPlotChart'"
    class="boxplotchart"
  >
    <VueApexCharts
      width="100%"
      type="boxPlot"
      :options="chartOptions"
      :series="formattedSeries"
    />
  </div>
</template>

<style scoped lang="scss">
.boxplotchart {
	margin: 1rem 0;
}
.chart-tooltip {
	background: #fff;
	border: 1px solid #ccc;
	padding: 0.5rem;
	border-radius: 4px;
	font-size: 0.8rem;
}
</style>
