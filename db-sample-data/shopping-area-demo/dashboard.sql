-- Table: public.shopping_area_new_tpe

-- DROP TABLE IF EXISTS public.shopping_area_new_tpe;

CREATE TABLE IF NOT EXISTS public.shopping_area_new_tpe
(
    business_district text COLLATE pg_catalog."default",
    chairman_of_the_board text COLLATE pg_catalog."default",
    tel text COLLATE pg_catalog."default",
    contact_person text COLLATE pg_catalog."default",
    cp_tel text COLLATE pg_catalog."default",
    countycode text COLLATE pg_catalog."default",
    areacode text COLLATE pg_catalog."default",
    addr text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    fax text COLLATE pg_catalog."default",
    "Longitude" numeric,
    "Latitude" numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.shopping_area_new_tpe
    OWNER to postgres;


-- Table: public.shopping_area_tpe

-- DROP TABLE IF EXISTS public.shopping_area_tpe;

CREATE TABLE IF NOT EXISTS public.shopping_area_tpe
(
    "分區" text COLLATE pg_catalog."default",
    "商圈名稱" text COLLATE pg_catalog."default",
    "組織或里辦公處" text COLLATE pg_catalog."default",
    "組織代表" text COLLATE pg_catalog."default",
    "職稱" text COLLATE pg_catalog."default",
    "聯絡電話" text COLLATE pg_catalog."default",
    "傳真" text COLLATE pg_catalog."default",
    "商圈通訊地址" text COLLATE pg_catalog."default",
    "Longitude" numeric,
    "Latitude" numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.shopping_area_tpe
    OWNER to postgres;