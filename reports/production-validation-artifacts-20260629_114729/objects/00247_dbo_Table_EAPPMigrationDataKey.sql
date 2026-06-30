-- ─── TABLE: EAPPMigrationDataKey ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPMigrationDataKey" (
    id serial NOT NULL,
    reporterid character varying(100),
    reportnum integer,
    eadocid integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
