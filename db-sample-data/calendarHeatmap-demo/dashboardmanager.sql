INSERT INTO public.component_charts (index, color, types, unit)
VALUES ('maokong_gondola', '{#b71c1c,#ff5252,#ffccbc,#1b5e20,#388e3c,#66bb6a,#a5d6a7,#e8f5e9,#e3f2fd}', '{CalendarHeatmapChart}', '人');

INSERT INTO public.components (id, index, name)
VALUES (300, 'maokong_gondola', '貓空纜車運量');

INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
VALUES ('maokong_gondola', 'null', null, 'null', 'static', null, null, null, '觀光局', '臺北捷運每日貓空纜車系統旅運量統計', '可以顯示臺北捷運每日貓空纜車系統旅運量。', '利用熱曆圖可觀察假日平日運量熱度差異，並且觀察出假日或特定時間是否有觀光成效。', '{https://data.taipei/dataset/detail?id=bed9c297-da71-4251-ba46-74d52ac9a991}', '{doit}', '2025-05-28 16:03:28.350000 +00:00', '2025-05-29 10:27:21.710038 +00:00', 'time', e'select
    x_axis,y_axis, data
from (
         select TO_TIMESTAMP(date_time::text , \'YYYYMMDD\') AT TIME ZONE \'Asia/Taipei\' AS x_axis,
                \'人數\' as y_axis,
                volume as data
         from
             "maokong_gondola"
     )d
order by 1', null, 'taipei');
