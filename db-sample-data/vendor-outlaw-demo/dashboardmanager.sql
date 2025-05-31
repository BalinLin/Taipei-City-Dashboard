-- components
INSERT INTO public.components(
	id, index, name)
	VALUES (401, 'vendor_outlaw', '攤販取締件數');

-- component_charts
INSERT INTO public.component_charts(
	index, color, types, unit)
	VALUES ('vendor_outlaw', '{#67baca,#fbf3ac}', '{ColumnLineChart}', '件');

-- query_charts 台北
INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('vendor_outlaw', null, '{}', null, 'static', null, null, null, '臺北市政府警察局', '顯示臺北市取締攤販件數統計', '此圖顯示臺北市歷年來取締攤販的件數統計，反映市府在公共空間管理與市容維護方面的執法強度與趨勢變化。透過不同時期的取締件數，可觀察街頭經濟活動的變動、違規攤販的活躍程度以及政策調整後的成效。取締件數的高低，不僅代表執法力度，也可能受到節慶活動、觀光流量、或經濟景氣的影響。藉由這類資料，市府可更有效規劃執法資源，提升市容整潔與街道通行秩序，同時兼顧民生經濟與社會公平，朝向更具彈性與包容性的治理模式邁進。', '可用於分析臺北市攤販管理政策的執行成效與趨勢評估，透過不同年度或月份的取締件數統計，判斷街頭經濟活動的強度變化與執法壓力的集中時段。本資料亦能搭配其他指標，如觀光人潮、民眾陳情件數或夜市經濟發展情況，進一步協助市府研擬更彈性化與地區化的攤販管理對策。此外，此圖也可做為調整基層執法人力、設置合法攤販區與推動智慧城市監管工具的依據，促進市容整潔與民生經濟的雙重平衡。', '{https://data.gov.tw/dataset/146741}', '{}', '2025-05-31 15:56:00+00', '2025-05-31 15:56:00+00', 'time', '
	SELECT x_axis, y_axis, data
FROM (
    SELECT
        TO_TIMESTAMP("年度" + 1911 || ''-'' || LPAD("月份"::TEXT, 2, ''0''), ''YYYY-MM'') AT TIME ZONE ''Asia/Taipei'' AS x_axis,
        ''案件數'' AS y_axis,
        "件數" AS data,
        2 AS sort_order
    FROM public.vendor_outlaw_tpe
    UNION ALL
    SELECT
        TO_TIMESTAMP("年度" + 1911 || ''-'' || LPAD("月份"::TEXT, 2, ''0''), ''YYYY-MM'') AT TIME ZONE ''Asia/Taipei'' AS x_axis,
        ''累積案件數'' AS y_axis,
        SUM("件數") OVER (PARTITION BY "年度" ORDER BY "月份") AS data,
        1 AS sort_order
    FROM public.vendor_outlaw_tpe
) AS combined_data
ORDER BY x_axis, sort_order;
', null, 'taipei');


-- query_charts 新北
INSERT INTO public.query_charts(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city)
	VALUES ('vendor_outlaw', null, '{}', null, 'static', null, null, null, '臺北市政府警察局及新北市政府警察局', '顯示雙北取締攤販件數統計', '此圖顯示雙北歷年來取締攤販的件數統計，反映市府在公共空間管理與市容維護方面的執法強度與趨勢變化。透過不同時期的取締件數，可觀察街頭經濟活動的變動、違規攤販的活躍程度以及政策調整後的成效。取締件數的高低，不僅代表執法力度，也可能受到節慶活動、觀光流量、或經濟景氣的影響。藉由這類資料，市府可更有效規劃執法資源，提升市容整潔與街道通行秩序，同時兼顧民生經濟與社會公平，朝向更具彈性與包容性的治理模式邁進。', '可用於分析雙北攤販管理政策的執行成效與趨勢評估，透過不同年度或月份的取締件數統計，判斷街頭經濟活動的強度變化與執法壓力的集中時段。本資料亦能搭配其他指標，如觀光人潮、民眾陳情件數或夜市經濟發展情況，進一步協助市府研擬更彈性化與地區化的攤販管理對策。此外，此圖也可做為調整基層執法人力、設置合法攤販區與推動智慧城市監管工具的依據，促進市容整潔與民生經濟的雙重平衡。', '{https://data.gov.tw/dataset/146741,https://data.gov.tw/dataset/123793}', '{}', '2025-05-31 15:56:00+00', '2025-05-31 15:56:00+00', 'time', '
	SELECT x_axis, y_axis, data
FROM (
    SELECT
        TO_TIMESTAMP(year_ + 1911 || ''-'' || LPAD(month_::TEXT, 2, ''0''), ''YYYY-MM'') AT TIME ZONE ''Asia/Taipei'' AS x_axis,
        ''案件數'' AS y_axis,
        SUM(month_total) AS data,
        2 AS sort_order
    FROM (
        SELECT "年度" AS year_, "月份" AS month_, "件數" AS month_total
        FROM public.vendor_outlaw_tpe
        UNION ALL
        SELECT "year" AS year_, "months" AS month_, SUM("number") AS month_total
        FROM public.vendor_outlaw_new_tpe
        WHERE organ = ''總　　　計''
        GROUP BY "year", "months"
    ) AS monthly_data
    GROUP BY year_, month_
    UNION ALL
    SELECT
        TO_TIMESTAMP(year_ + 1911 || ''-'' || LPAD(month_::TEXT, 2, ''0''), ''YYYY-MM'') AT TIME ZONE ''Asia/Taipei'' AS x_axis,
        ''累積案件數'' AS y_axis,
        SUM(SUM(month_total)) OVER (PARTITION BY year_ ORDER BY month_) AS data,
        1 AS sort_order
    FROM (
        SELECT "年度" AS year_, "月份" AS month_, "件數" AS month_total
        FROM public.vendor_outlaw_tpe
        UNION ALL
        SELECT "year" AS year_, "months" AS month_, SUM("number") AS month_total
        FROM public.vendor_outlaw_new_tpe
        WHERE organ = ''總　　　計''
        GROUP BY "year", "months"
    ) AS monthly_data
    GROUP BY year_, month_
) AS combined_data
ORDER BY x_axis, sort_order;
', null, 'metrotaipei');