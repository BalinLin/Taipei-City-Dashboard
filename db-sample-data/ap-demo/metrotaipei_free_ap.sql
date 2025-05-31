INSERT INTO public.component_charts(
	index, color, types, unit)
	VALUES ('free_ap', '{#E6DF44,#F4633C,#D63940,#9C2A4B}', '{DistrictChart,ColumnChart}', '處');

INSERT INTO public.components(
	index, name)
	VALUES ('free_ap', '免費熱點');

INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('free_ap', null, null, null, 'static', null, null, null, '新北市政府研究發展考核委員會', null, null, null, '{https://data.ntpc.gov.tw/datasets/04958686-1b92-4b74-889d-9f34409b272b}', '{doit}', '2025-05-31 14:10:00+00', '2025-05-31 14:10:00+00', 'two_d', '
SELECT * FROM (
SELECT
	district as x_axis,
	COUNT(*) AS data
FROM public.metrotaipei_free_ap
GROUP BY
	x_axis
UNION
SELECT
	district as x_axis,
	COUNT(*) AS data
FROM public.taipei_free_ap
GROUP BY
	x_axis
) as t
ORDER BY
	ARRAY_POSITION(ARRAY[''北投區'', ''士林區'', ''內湖區'', ''南港區'', ''松山區'', ''信義區'', ''中山區'', ''大同區'', ''中正區'', ''萬華區'', ''大安區'', ''文山區'', ''新莊區'', ''淡水區'', ''汐止區'', ''板橋區'', ''三重區'', ''樹林區'', ''土城區'', ''蘆洲區'', ''中和區'', ''永和區'', ''新店區'', ''鶯歌區'', ''三峽區'', ''瑞芳區'', ''五股區'', ''泰山區'', ''林口區'', ''深坑區'', ''石碇區'', ''坪林區'', ''三芝區'', ''石門區'', ''八里區'', ''平溪區'', ''雙溪區'', ''貢寮區'', ''金山區'', ''萬里區'', ''烏來區''], t.x_axis);
	', null, 'metrotaipei');

INSERT INTO public.component_maps(
	index, title, type, source, size, icon, paint, property)
	VALUES ('metrotaipei_free_ap', '免費熱點', 'circle', 'geojson', null, null, '{"circle-color": ["case",
    ["==", ["get", "type"], "臺北市"], "#E6DF44",
    "#9C2A4B"]}', '[{"key": "district", "name": "行政區"}, {"key": "company", "name": "類型"}, {"key": "address", "name": "地址"}, {"key": "spot_name", "name": "熱點名稱"}]');

UPDATE public.query_charts
	SET map_config_ids='{6, 7}', map_filter='{"mode":"byParam","byParam":{"xParam":"district"}}'
	WHERE index='free_ap' and city='metrotaipei';
