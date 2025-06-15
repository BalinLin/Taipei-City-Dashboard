-- Table: public.visit_purpose

-- DROP TABLE IF EXISTS public.visit_purpose;

CREATE TABLE IF NOT EXISTS public.visit_purpose
(
    "日期" text COLLATE pg_catalog."default",
    "觀光目的別" text COLLATE pg_catalog."default",
    "目的別總計" numeric,
    "業務" numeric,
    "觀光" numeric,
    "探親" numeric,
    "會議" numeric,
    "求學" numeric,
    "展覽" numeric,
    "醫療" numeric,
    "其他" numeric,
    "未列明" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.visit_purpose
    OWNER to postgres;
