INSERT INTO public.component_charts(
	index, color, types, unit)
	VALUES ('garbage_truck', '{#E6DF44,#F4633C,#D63940,#9C2A4B}', '{ColumnChart}', '處');

INSERT INTO public.components(
	index, name)
	VALUES ('garbage_truck', '垃圾車收運點位');

INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('garbage_truck', null, null, null, 'static', null, null, null, '環保局', null, null, null, '{https://data.taipei/dataset/detail?id=6bb3304b-4f46-4bb0-8cd1-60c66dcd1cae}', '{doit}', '2025-05-20 15:56:00+00', '2025-05-20 15:56:00+00', 'three_d', 'SELECT * FROM (
SELECT
	行政區 as x_axis,
	CASE
		WHEN 抵達時間 BETWEEN 0 AND 1659 THEN ''1700前''
		WHEN 抵達時間 BETWEEN 1700 AND 1859 THEN ''1700-1900''
		WHEN 抵達時間 BETWEEN 1900 AND 2059 THEN ''1900-2100''
		ELSE ''2100後''
	END AS y_axis,
	COUNT(*) AS data
FROM public.garbage_truck
GROUP BY
	行政區,
	CASE
		WHEN 抵達時間 BETWEEN 0 AND 1659 THEN ''1700前''
		WHEN 抵達時間 BETWEEN 1700 AND 1859 THEN ''1700-1900''
		WHEN 抵達時間 BETWEEN 1900 AND 2059 THEN ''1900-2100''
		ELSE ''2100後''
	END
) as t
ORDER BY
	ARRAY_POSITION(ARRAY[''北投區'', ''士林區'', ''內湖區'', ''南港區'', ''松山區'', ''信義區'', ''中山區'', ''大同區'', ''中正區'', ''萬華區'', ''大安區'', ''文山區'', ''新莊區'', ''淡水區'', ''汐止區'', ''板橋區'', ''三重區'', ''樹林區'', ''土城區'', ''蘆洲區'', ''中和區'', ''永和區'', ''新店區'', ''鶯歌區'', ''三峽區'', ''瑞芳區'', ''五股區'', ''泰山區'', ''林口區'', ''深坑區'', ''石碇區'', ''坪林區'', ''三芝區'', ''石門區'', ''八里區'', ''平溪區'', ''雙溪區'', ''貢寮區'', ''金山區'', ''萬里區'', ''烏來區''], t.x_axis),
	ARRAY_POSITION(ARRAY[''1700前'', ''1700-1900'', ''1900-2100'', ''2100後''], t.y_axis);
	', null, 'taipei');

INSERT INTO public.component_maps(
	index, title, type, source, size, icon, paint, property)
	VALUES ('garbage_truck', '垃圾車收運點位', 'circle', 'geojson', null, null, '{"circle-color": ["case", ["<", ["get", "抵達時間"], 1700], "#E6DF44", ["<", ["get", "抵達時間"], 1900], "#F4633C", ["<", ["get", "抵達時間"], 2100], "#D63940", "#9C2A4B"]}', '[{"key": "行政區", "name": "行政區"}, {"key": "抵達時間", "name": "抵達時間"}, {"key": "離開時間", "name": "離開時間"}, {"key": "地點", "name": "地址"}]');

UPDATE public.query_charts
	SET map_config_ids='{1}', map_filter='{"mode":"byParam","byParam":{"xParam":"行政區"}}'
	WHERE index='garbage_truck';
