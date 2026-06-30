-- ─── TABLE: EAPPDocDuty ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocDuty" (
    seq serial NOT NULL,
    eadocid integer,
    dutycode character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
