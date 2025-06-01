-- components
INSERT INTO public.components(
	id, index, name)
	VALUES (403, 'taxi_stand', '計程車招呼站');

-- component_charts
INSERT INTO public.component_charts(
	index, color, types, unit)
	VALUES ('taxi_stand', '{#4DA6FF,#0059B3,#FFFFFF}', '{BoxPlotChart}', '站');

-- query_charts 台北
INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit,
	source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at,
	query_type, query_chart, query_history, city
) VALUES (
	'taxi_stand',
	null,
	'{402}',
	null,
	'static',
	null,
	null,
	null,
	'臺北市公共運輸處',
	'顯示臺北市計程車招呼站',
	'此圖顯示臺北市各行政區的計程車招呼站分布情形，反映各地區交通服務的佈設密度與使用需求。圖表可觀察出不同區域招呼站的設置數量，呈現市民通勤便利性、觀光熱點與交通樞紐的地理特性。透過這些資料，有助於掌握大眾運輸與計程車資源的配置情況，進而協助市府在公共運輸政策上進行精準調整。計程車招呼站的多寡不僅關係到交通接駁效率，也影響都市交通秩序與市民生活品質，能為交通基礎設施的優化、觀光動線設計及智慧交通系統建置提供重要依據。',
	'可用於分析臺北市各行政區計程車服務的可及性與交通便利程度，透過圖表呈現不同區域招呼站的設置情形與密度差異。結合人口分布、觀光景點、商業區與交通樞紐等資料，可評估交通服務的供需平衡與潛在缺口。此數據有助於臺北市政府在推動智慧交通、改善大眾運輸接駁效率與提升旅遊接待能力等政策中作為決策依據。同時也能作為規劃新設招呼站、優化現有交通節點與提升民眾搭乘便利性的參考，促進整體都市交通系統的完善與永續發展。',
	'{https://data.gov.tw/dataset/134597}',
	'{}',
	'2025-05-31 15:56:00+00',
	'2025-05-31 15:56:00+00',
	'three_d',
	'
WITH parsed_time_slots AS (
  SELECT *,
    地區 || ''區'' AS full_district,
    CASE
      WHEN 排班時間 ~ ''^(.*)?(5|6|7|8|9|10|11)[^\\d]*(11|12|13|14|15|16|17)(.*)?$'' THEN ''早午班''
      WHEN 排班時間 ~ ''^(.*)?(11|12|13|14|15|16|17)[^\\d]*(17|18|19|20|21|22|23|24)?(.*)?$'' THEN ''午晚班''
      WHEN 排班時間 ~ ''^(.*)?(5|6|7|8|9|10|11)(.*)?$'' THEN ''早班''
      WHEN 排班時間 ~ ''^(.*)?(11|12|13|14|15|16|17)(.*)?$'' THEN ''午班''
      WHEN 排班時間 ~ ''^(.*)?(17|18|19|20|21|22|23|24)(.*)?$'' THEN ''晚班''
      ELSE ''其他''
    END AS shift_group
  FROM taxi_stand
),
district_counts AS (
  SELECT
    shift_group AS x_axis,
    full_district AS district,
    COUNT(*) AS count
  FROM parsed_time_slots
  WHERE shift_group != ''其他''
  GROUP BY shift_group, full_district
),
sorted_counts AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY x_axis ORDER BY count) AS row_num,
         COUNT(*) OVER (PARTITION BY x_axis) AS total
  FROM district_counts
),
five_number_summary AS (
  SELECT
    x_axis,
    MIN(count) FILTER (WHERE row_num = 1) AS min,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY count)) AS q1,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY count)) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY count)) AS q3,
    MAX(count) FILTER (WHERE row_num = total) AS max
  FROM sorted_counts
  GROUP BY x_axis
),
unnested_summary AS (
  SELECT x_axis, ''min'' AS y_axis, min AS data FROM five_number_summary
  UNION ALL
  SELECT x_axis, ''q1'', q1 FROM five_number_summary
  UNION ALL
  SELECT x_axis, ''median'', median FROM five_number_summary
  UNION ALL
  SELECT x_axis, ''q3'', q3 FROM five_number_summary
  UNION ALL
  SELECT x_axis, ''max'', max FROM five_number_summary
)
SELECT *
FROM unnested_summary
ORDER BY x_axis,
  CASE y_axis
    WHEN ''min'' THEN 1
    WHEN ''q1'' THEN 2
    WHEN ''median'' THEN 3
    WHEN ''q3'' THEN 4
    WHEN ''max'' THEN 5
  END;
',
	null,
	'taipei'
);

-- component_maps 台北
INSERT INTO public.component_maps(
	id, index, title, type, source, size, icon, paint, property)
	VALUES (402, 'taxi_stand', '計程車招呼站', 'symbol', 'geojson', null, 'taxi', '{}', '[{"key": "分區", "name": "行政區"}, {"key": "商圈名稱", "name": "商圈名稱"}]');