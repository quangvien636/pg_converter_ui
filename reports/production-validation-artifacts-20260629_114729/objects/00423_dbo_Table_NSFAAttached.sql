-- ─── TABLE: NSFAAttached ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFAAttached" (
    Seq serial NOT NULL,
    ParentSeq integer NOT NULL,
    Attnum integer,
    Attname character varying(200),
    RegId character varying(100),
    RegYmd character(8)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
