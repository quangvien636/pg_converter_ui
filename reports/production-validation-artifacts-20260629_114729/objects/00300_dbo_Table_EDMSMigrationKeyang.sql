-- ─── TABLE: EDMSMigrationKeyang ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSMigrationKeyang" (
    Seq serial NOT NULL,
    EDMSID integer,
    MigrationID character varying(100),
    GroupCode character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
