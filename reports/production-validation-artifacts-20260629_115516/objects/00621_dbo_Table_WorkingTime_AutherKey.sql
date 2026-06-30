-- ─── TABLE: WorkingTime_AutherKey ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_AutherKey" (
    AuthNo serial NOT NULL,
    Value character varying(100),
    statusi integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
