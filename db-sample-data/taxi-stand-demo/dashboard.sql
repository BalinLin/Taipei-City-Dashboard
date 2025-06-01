-- Table: public.taxi_stand

-- DROP TABLE IF EXISTS public.taxi_stand;

CREATE TABLE IF NOT EXISTS public.taxi_stand
(
    "項次" integer,
    "地區" text COLLATE pg_catalog."default",
    "經度X" numeric,
    "緯度Y" numeric,
    "設置地點" text COLLATE pg_catalog."default",
    "街道名稱" text COLLATE pg_catalog."default",
    "排班格位" integer,
    "排班時間" text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.taxi_stand
    OWNER to postgres;