-- components
INSERT INTO public.components(
	id, index, name)
	VALUES (402, 'taipei_expo_vendor', '台北花博農民市集全國農特產品展售會業績');

-- component_charts
INSERT INTO public.component_charts(
	index, color, types, unit)
	VALUES ('taipei_expo_vendor', '{#24B0DD,#F5AD4A}', '{ColumnLineChart}', '');

-- query_charts 台北
INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit,
	source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at,
	query_type, query_chart, query_history, city
) VALUES (
	'taipei_expo_vendor',
	null,
	'{}',
	null,
	'static',
	null,
	null,
	null,
	'臺北市政府產業發展局',
	'顯示台北花博農民市集全國農特產品展售會業績',
	'此圖顯示台北花博農民市集於全國農特產品展售會期間的業績表現，反映不同時間或地區參與狀況與銷售成果。圖表呈現各檔期農產品銷售額的變化趨勢，展現出消費者對在地農特產品的支持程度與市集活動的吸引力。透過業績資料分析，可瞭解各地農民團體參與展售的成效，有助於政府評估市集經營效益與農產品行銷策略的可行性。此資訊亦有助於掌握農產品供應與需求動態，作為未來推動地方農業發展、展售資源分配與促銷活動規劃的重要參考依據。',
	'可用於分析台北花博農民市集在全國農特產品展售會期間之營運成效，透過業績數據比較不同時段與區域的銷售表現，進一步評估各檔期市場接受度與產品偏好。圖表可結合參展農會地區、產品類型與行銷手法等變數，辨識出高效銷售模式與潛在改進空間。此資料有助於相關單位調整活動規模與舉辦頻率，並針對農民團體提供更具精準性的輔導與資源配置。同時也能作為地方政府發展農業品牌、推動農產加值與推廣地產地銷的策略基礎，強化農業經濟體系並提升都市消費市場與產地端之連結。',
	'{https://data.gov.tw/dataset/121860}',
	'{}',
	'2025-05-31 15:56:00+00',
	'2025-05-31 15:56:00+00',
	'time',
	'
SELECT x_axis, y_axis, data
FROM (
    SELECT
        TO_DATE(SPLIT_PART("日期", ''-'', 1), ''YYYY/MM/DD'') AS x_axis,
        ''平均來客數'' AS y_axis,
        ROUND(("小計（來客數）"::FLOAT / NULLIF("展售攤數", 0))::NUMERIC, 2) AS data,
        1 AS sort_order
    FROM public.taipei_expo_vendor
    UNION ALL
    SELECT
        TO_DATE(SPLIT_PART("日期", ''-'', 1), ''YYYY/MM/DD'') AS x_axis,
        ''平均營業額'' AS y_axis,
        ROUND(("小計（營業額）"::FLOAT / NULLIF("展售攤數", 0))::NUMERIC, 2) AS data,
        2 AS sort_order
    FROM public.taipei_expo_vendor
) AS combined_data
ORDER BY x_axis, sort_order;
',
	null,
	'taipei'
);
