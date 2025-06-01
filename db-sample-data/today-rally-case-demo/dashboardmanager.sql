INSERT INTO public.components (id, index, name) VALUES (315, 'today_rally_case', '使用道路集會路段');


INSERT INTO public.component_maps (id, index, title, type, source, size, icon, paint, property) VALUES (315, 'today_rally_case_taipei', '臺北市今日使用道路集會路段', 'fill', 'geojson', null, null, e'{
  "fill-color": "#a0b8e8",
  "fill-opacity": 0.5
}', '[{"key": "RAL_END_DATE", "name": "結束時間"}]');
INSERT INTO public.component_maps (id, index, title, type, source, size, icon, paint, property) VALUES (316, 'today_rally_case_extend_taipei', '臺北市今日使用道路集會路段', 'fill', 'geojson', null, null, e'{
  "fill-color": "#a0b8e8",
  "fill-opacity": 0.1
}', '[{"key": "RAL_END_DATE", "name": "結束時間"}]');


INSERT INTO public.component_charts (index, color, types, unit) VALUES ('today_rally_case', '{#a0b8e8,#b7ff98}', '{MapLegend}', '條');


INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city) VALUES ('today_rally_case', null, '{315,316}', null, 'static', null, null, null, '工務局新工處', '臺北市今日使用道路集會路段', '臺北市今日使用道路集會路段', '臺北市今日使用道路集會路段', '{https://data.taipei/dataset/detail?id=aaea574f-9264-4d9f-b4cd-5b0fced7e37c}', '{doit}', '2025-06-01 07:59:28.568000 +00:00', '2025-06-01 07:59:29.504000 +00:00', 'map_legend', 'SELECT unnest(array[''集會'']) as name, ''line'' as type', null, 'taipei');
