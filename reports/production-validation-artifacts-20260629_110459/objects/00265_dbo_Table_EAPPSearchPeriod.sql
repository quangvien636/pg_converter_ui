-- ─── TABLE: EAPPSearchPeriod ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPSearchPeriod" (
    userid character varying(50) NOT NULL PRIMARY KEY,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    valdate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
