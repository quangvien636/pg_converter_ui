-- ─── TABLE: Center_Holidays ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_Holidays" (
    HolidayNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    GroupNo integer NOT NULL,
    HolidayType integer NOT NULL,
    HolidayDate character varying(50) NOT NULL,
    Lunar character(1) NOT NULL,
    Substitution character(1) NOT NULL,
    Title character varying(100) NOT NULL,
    Description character varying(1000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
