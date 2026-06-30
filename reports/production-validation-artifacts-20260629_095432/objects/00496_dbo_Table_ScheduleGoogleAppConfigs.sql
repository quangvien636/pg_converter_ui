-- ─── TABLE: ScheduleGoogleAppConfigs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleGoogleAppConfigs" (
    Id serial NOT NULL,
    ConfigName character varying(100),
    domainName character varying(500),
    JsonData text NOT NULL,
    CreatedAt timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
