-- Table: public.vendor_outlaw_tpe

-- DROP TABLE IF EXISTS public.vendor_outlaw_tpe;

CREATE TABLE IF NOT EXISTS public.vendor_outlaw_tpe
(
    "機關代碼" text COLLATE pg_catalog."default",
    "年度" integer,
    "月份" integer,
    "名稱" text COLLATE pg_catalog."default",
    "件數" integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vendor_outlaw_tpe
    OWNER to postgres;


-- Table: public.vendor_outlaw_new_tpe

-- DROP TABLE IF EXISTS public.vendor_outlaw_new_tpe;

CREATE TABLE IF NOT EXISTS public.vendor_outlaw_new_tpe
(
    year integer,
    months integer,
    organ text COLLATE pg_catalog."default",
    kind text COLLATE pg_catalog."default",
    "number" integer,
    numofpeople integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vendor_outlaw_new_tpe
    OWNER to postgres;