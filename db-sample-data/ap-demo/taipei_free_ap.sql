INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('free_ap', null, null, null, 'static', null, null, null, '資訊局', null, null, null, '{https://data.taipei/dataset/detail?id=6aa6532d-652f-4c1b-814a-4646b75407af}', '{doit}', '2025-05-31 14:48:00+00', '2025-05-31 14:48:00+00', 'two_d', '
SELECT * FROM (
SELECT
	district as x_axis,
	COUNT(*) AS data
FROM public.taipei_free_ap
GROUP BY
	x_axis
) as t
ORDER BY
	ARRAY_POSITION(ARRAY[''北投區'', ''士林區'', ''內湖區'', ''南港區'', ''松山區'', ''信義區'', ''中山區'', ''大同區'', ''中正區'', ''萬華區'', ''大安區'', ''文山區'', ''新莊區'', ''淡水區'', ''汐止區'', ''板橋區'', ''三重區'', ''樹林區'', ''土城區'', ''蘆洲區'', ''中和區'', ''永和區'', ''新店區'', ''鶯歌區'', ''三峽區'', ''瑞芳區'', ''五股區'', ''泰山區'', ''林口區'', ''深坑區'', ''石碇區'', ''坪林區'', ''三芝區'', ''石門區'', ''八里區'', ''平溪區'', ''雙溪區'', ''貢寮區'', ''金山區'', ''萬里區'', ''烏來區''], t.x_axis);
	', null, 'taipei');

INSERT INTO public.component_maps(
	index, title, type, source, size, icon, paint, property)
	VALUES ('taipei_free_ap', '免費熱點', 'circle', 'geojson', null, null, '{"circle-color": ["case",
    ["==", ["get", "county"], "臺北市"], "#E6DF44",
    "#9C2A4B"]}', '[{"key": "district", "name": "行政區"}, {"key": "STYPE", "name": "類型"}, {"key": "ADDR", "name": "地址"}, {"key": "SITE_ID", "name": "熱點名稱"}]');

UPDATE public.query_charts
	SET map_config_ids='{7}', map_filter='{"mode":"byParam","byParam":{"xParam":"district"}}'
	WHERE index='free_ap' and city='taipei';
