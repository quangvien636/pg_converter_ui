-- ─── TABLE: Center_HolidayGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_HolidayGroups" (
    GroupNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Title character varying(100) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
