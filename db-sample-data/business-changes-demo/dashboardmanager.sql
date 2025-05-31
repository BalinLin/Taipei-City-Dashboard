INSERT INTO public.components (id, index, name) VALUES (310, 'business_changes', '商業行號異動');

INSERT INTO public.component_charts (index, color, types, unit) VALUES ('business_changes', '{#f66151,#57e389}', '{DistrictChart,ColumnChart}', '家');

INSERT INTO public.component_maps (id, index, title, type, source, size, icon, paint, property) VALUES (310, 'business_changes_taipei', '商業行號異動', 'circle', 'geojson', null, null, e'{
  "circle-color": [
    "case",
    ["!=", ["get", "歇業日期"], null], "#4CAF50",
    "#F44336"
  ],
  "circle-radius": 3
}', '[{"key":"商業名稱","name":"商業名稱"},{"key":"設立日期","name":"設立日期"},{"key":"歇業日期","name":"歇業日期"}]');


INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city) VALUES ('business_changes', 'null', '{310}', '{"mode":"byParam","byParam":{"xParam":"行政區"}}', 'static', null, 1, 'month', '產業局商業處', '商業設立異動數', null, null, '{https://data.taipei/dataset/detail?id=d32fe131-6965-47e3-9433-7352a2ff2681}', '{doit}', '2025-05-31 19:24:21.996000 +00:00', '2025-05-31 13:59:24.622588 +00:00', 'two_d', e'SELECT
    COALESCE(a.district, c.district) AS x_axis,
    COALESCE(a.count, 0) - COALESCE(c.count, 0) AS data
FROM (
         SELECT district, COUNT(*) AS count
         FROM "business_apply_tpe"
         GROUP BY district
     ) a
         FULL OUTER JOIN (
    SELECT district, COUNT(*) AS count
    FROM "business_close_tpe"
    GROUP BY district
) c
    ON  a.district = c.district
ORDER BY ARRAY_POSITION(
                 ARRAY[\'北投區\', \'士林區\', \'內湖區\', \'南港區\', \'松山區\', \'信義區\', \'中山區\', \'大同區\', \'中正區\', \'萬華區\', \'大安區\', \'文山區\', \'新莊區\', \'淡水區\', \'汐止區\', \'板橋區\', \'三重區\', \'樹林區\', \'土城區\', \'蘆洲區\', \'中和區\', \'永和區\', \'新店區\', \'鶯歌區\', \'三峽區\', \'瑞芳區\', \'五股區\', \'泰山區\', \'林口區\', \'深坑區\', \'石碇區\', \'坪林區\', \'三芝區\', \'石門區\', \'八里區\', \'平溪區\', \'雙溪區\', \'貢寮區\', \'金山區\', \'萬里區\', \'烏來區\'],
                 COALESCE(a.district, c.district)
         );
', null, 'taipei');
INSERT INTO public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city) VALUES ('business_changes', 'null', null, 'null', 'static', null, 1, 'month', '產業局商業處', '商業設立異動數', null, null, '{https://data.taipei/dataset/detail?id=d32fe131-6965-47e3-9433-7352a2ff2681,https://data.gov.tw/dataset/125322}', '{doit}', '2025-05-31 19:24:21.996000 +00:00', '2025-05-31 13:59:17.548737 +00:00', 'two_d', e'SELECT
    COALESCE(a.district, b.district, c.district, d.district) AS x_axis,
    COALESCE(a.count, c.count, 0) - COALESCE(b.count, d.count, 0) AS data
FROM (
         SELECT district, COUNT(*) AS count
         FROM "business_apply_new_tpe"
         GROUP BY district
     ) a
         FULL OUTER JOIN (
    SELECT district, COUNT(*) AS count
    FROM "business_close_new_tpe"
    GROUP BY district
) b ON a.district = b.district
         FULL OUTER JOIN (
    SELECT district, COUNT(*) AS count
    FROM "business_apply_tpe"
    GROUP BY district
) c ON COALESCE(a.district, b.district) = c.district
         FULL OUTER JOIN (
    SELECT district, COUNT(*) AS count
    FROM "business_close_tpe"
    GROUP BY district
) d ON COALESCE(a.district, b.district, c.district) = d.district
ORDER BY ARRAY_POSITION(
                 ARRAY[\'北投區\', \'士林區\', \'內湖區\', \'南港區\', \'松山區\', \'信義區\', \'中山區\', \'大同區\', \'中正區\', \'萬華區\', \'大安區\', \'文山區\', \'新莊區\', \'淡水區\', \'汐止區\', \'板橋區\', \'三重區\', \'樹林區\', \'土城區\', \'蘆洲區\', \'中和區\', \'永和區\', \'新店區\', \'鶯歌區\', \'三峽區\', \'瑞芳區\', \'五股區\', \'泰山區\', \'林口區\', \'深坑區\', \'石碇區\', \'坪林區\', \'三芝區\', \'石門區\', \'八里區\', \'平溪區\', \'雙溪區\', \'貢寮區\', \'金山區\', \'萬里區\', \'烏來區\'],
                 COALESCE(a.district, b.district, c.district, d.district)
         );
', null, 'metrotaipei');
