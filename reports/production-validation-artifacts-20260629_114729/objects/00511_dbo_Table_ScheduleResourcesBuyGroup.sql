-- ─── TABLE: ScheduleResourcesBuyGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourcesBuyGroup" (
    BuyGroupNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    CompanyName character varying(200) NOT NULL,
    BuyDate date NOT NULL,
    BuyQty integer NOT NULL,
    BuyAmount numeric(18,0) NOT NULL,
    MainManagerNo integer NOT NULL,
    SubManagerNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
