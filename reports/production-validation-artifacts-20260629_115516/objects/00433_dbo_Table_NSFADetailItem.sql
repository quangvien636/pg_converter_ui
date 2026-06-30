-- ─── TABLE: NSFADetailItem ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFADetailItem" (
    Seq serial NOT NULL,
    Name character varying(50),
    Flag integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
