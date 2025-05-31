-- components
INSERT INTO public.components(
	id, index, name)
	VALUES (400, 'shopping_area', '全市商圈分區');

-- component_charts
INSERT INTO public.component_charts(
	index, color, types, unit)
	VALUES ('shopping_area', '{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}', '{DistrictChart,ColumnChart}', '處');

-- query_charts 台北
INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('shopping_area', null, '{400}', null, 'static', null, null, null, '臺北市商業處', '顯示臺北各區的商圈數量', '此圖顯示臺北市各行政區的商圈數量分布，呈現各地區商業活動的集中程度與發展規模。圖表可看出不同分區的商圈密度，反映當地的經濟活絡度與生活機能強度。透過這些資料，可協助政府瞭解商業資源的地理分布，進而規劃更具針對性的區域經濟政策與都市更新方向。商圈數量的多寡不僅關乎消費便利與就業機會，也影響市政基礎建設與交通運輸的配置，有助於推動區域均衡發展、提升都市競爭力，並為民間投資與創業提供參考依據。', '可用於分析臺北市各行政區商業發展的分布情形，透過此圖顯示各區商圈的數量與集中程度。圖表呈現不同區域的商圈密度差異，並可結合都市發展政策、人口結構與交通可及性等因素，評估商業活動的熱區與潛力地帶。透過這些數據，可進一步了解商業資源是否均衡配置，有助於臺北市政府推動區域振興、招商引資及地方創生等政策方向。同時也能作為調整基礎設施建設、都市更新計畫與交通路網規劃的參考依據，促進城市經濟永續與民生便利的雙重目標邁進。', '{https://data.gov.tw/dataset/121157}', '{}', '2025-05-31 15:56:00+00', '2025-05-31 15:56:00+00', 'two_d', 'SELECT x_axis, COUNT(商圈名稱) AS data
FROM (
    SELECT DISTINCT ON (分區, 商圈名稱)
        分區 AS x_axis,
        商圈名稱
    FROM public.shopping_area_tpe
    WHERE 分區 IS NOT NULL
      AND 商圈名稱 IS NOT NULL
      AND 商圈通訊地址 IS NOT NULL
    ORDER BY 分區, 商圈名稱
) AS t
GROUP BY x_axis
ORDER BY
	ARRAY_POSITION(ARRAY[''北投區'', ''士林區'', ''內湖區'', ''南港區'', ''松山區'', ''信義區'', ''中山區'', ''大同區'', ''中正區'', ''萬華區'', ''大安區'', ''文山區'', ''新莊區'', ''淡水區'', ''汐止區'', ''板橋區'', ''三重區'', ''樹林區'', ''土城區'', ''蘆洲區'', ''中和區'', ''永和區'', ''新店區'', ''鶯歌區'', ''三峽區'', ''瑞芳區'', ''五股區'', ''泰山區'', ''林口區'', ''深坑區'', ''石碇區'', ''坪林區'', ''三芝區'', ''石門區'', ''八里區'', ''平溪區'', ''雙溪區'', ''貢寮區'', ''金山區'', ''萬里區'', ''烏來區''], t.x_axis);
', null, 'taipei');


-- query_charts 新北
INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('shopping_area', null, '{400,401}', null, 'static', null, null, null, '臺北市商業處及新北市政府經濟發展局', '顯示雙北各區的商圈數量', '此圖顯示雙北兩市各行政區的商圈數量分布，呈現各地區商業活動的集中程度與發展規模。圖表可看出不同分區的商圈密度，反映當地的經濟活絡度與生活機能強度。透過這些資料，可協助政府瞭解商業資源的地理分布，進而規劃更具針對性的區域經濟政策與都市更新方向。商圈數量的多寡不僅關乎消費便利與就業機會，也影響市政基礎建設與交通運輸的配置，有助於推動區域均衡發展、提升都市競爭力，並為民間投資與創業提供參考依據。', '可用於分析臺北市各行政區商業發展的分布情形，透過此圖顯示各區商圈的數量與集中程度。圖表呈現不同區域的商圈密度差異，並可結合都市發展政策、人口結構與交通可及性等因素，評估商業活動的熱區與潛力地帶。透過這些數據，可進一步了解商業資源是否均衡配置，有助於臺北市政府推動區域振興、招商引資及地方創生等政策方向。同時也能作為調整基礎設施建設、都市更新計畫與交通路網規劃的參考依據，促進城市經濟永續與民生便利的雙重目標邁進。', '{https://data.ntpc.gov.tw/datasets/f54ded71-eb04-466d-bb6d-dd948c8d8502,https://data.gov.tw/dataset/121157}', '{}', '2025-05-31 15:56:00+00', '2025-05-31 15:56:00+00', 'two_d', '
	SELECT x_axis, SUM(data) AS data
FROM (
    SELECT "分區" AS x_axis, COUNT(DISTINCT "商圈名稱") AS data
    FROM shopping_area_tpe
    WHERE "分區" IS NOT NULL
      AND "商圈名稱" IS NOT NULL
      AND "商圈通訊地址" IS NOT NULL
    GROUP BY 分區
    UNION ALL
    SELECT TRIM(REGEXP_REPLACE(SPLIT_PART(addr, ''市'', 2), E''^([^\d]+區).*$'', ''\1'', ''g'')) AS x_axis,
           COUNT(DISTINCT business_district) AS data
    FROM public.shopping_area_new_tpe
    WHERE addr LIKE ''%市%'' AND addr LIKE ''%區%''
    GROUP BY x_axis
) AS combined_data
GROUP BY x_axis
ORDER BY
    ARRAY_POSITION(ARRAY[
        ''北投區'', ''士林區'', ''內湖區'', ''南港區'', ''松山區'', ''信義區'', ''中山區'', ''大同區'', ''中正區'',
        ''萬華區'', ''大安區'', ''文山區'', ''新莊區'', ''淡水區'', ''汐止區'', ''板橋區'', ''三重區'', ''樹林區'',
        ''土城區'', ''蘆洲區'', ''中和區'', ''永和區'', ''新店區'', ''鶯歌區'', ''三峽區'', ''瑞芳區'', ''五股區'',
        ''泰山區'', ''林口區'', ''深坑區'', ''石碇區'', ''坪林區'', ''三芝區'', ''石門區'', ''八里區'', ''平溪區'',
        ''雙溪區'', ''貢寮區'', ''金山區'', ''萬里區'', ''烏來區''
    ], x_axis);
', null, 'metrotaipei');


-- component_maps 台北
INSERT INTO public.component_maps(
	id, index, title, type, source, size, icon, paint, property)
	VALUES (400, 'shopping_area_tpe', '全市商圈分區', 'symbol', 'geojson', null, 'shopping_bag', '{}', '[{"key": "分區", "name": "行政區"}, {"key": "商圈名稱", "name": "商圈名稱"}]');

-- component_maps 新北
INSERT INTO public.component_maps(
	id, index, title, type, source, size, icon, paint, property)
	VALUES (401, 'shopping_area_metrotpe', '全市商圈分區', 'symbol', 'geojson', null, 'shopping_bag', '{}', '[{"key": "分區", "name": "行政區"}, {"key": "商圈名稱", "name": "商圈名稱"}]');