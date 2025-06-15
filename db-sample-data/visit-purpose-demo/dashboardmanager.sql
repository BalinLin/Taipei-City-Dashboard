INSERT INTO public.component_charts (index, color, types, unit)
VALUES ('visit_purpose', '{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}', '{{BarPercentChart,RadarChart,ColumnChart}}', '人');

INSERT INTO public.components (id, index, name)
VALUES (10, 'visit_purpose', '貓空纜車運量');

INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
VALUES ('visit_purpose', 'null', null, 'null', 'static', null, null, null, '中華民國統計資訊網', '來臺旅客人數按居住地及目的別分', '可以顯示來臺旅客人數按居住地及目的別分。', '', '{https://statis.motc.gov.tw/motc/Statistics/Display?Seq=309&lang=zh-Hant-TW}', '{doit}', '2025-06-01 09:03:28.350000 +00:00', '2025-06-01 09:03:28.350000 +00:00', 'time', e'
select
    x_axis,y_axis, data
from (
         select TO_TIMESTAMP(\'日期\'::text , \'YYYYMMDD\') AT TIME ZONE \'Asia/Taipei\' AS x_axis,
                \'人數\' as y_axis,
                volume as data
         from
             "visit_purpose"
     )d
order by 1', null, 'metrotaipei');
