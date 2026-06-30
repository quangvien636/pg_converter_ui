-- ─── TABLE: ScheduleResourceCategories ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceCategories" (
    CategoryNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
