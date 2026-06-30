-- ─── TABLE: NSFAFileInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFAFileInfo" (
    Seq serial NOT NULL,
    ParentSeq integer NOT NULL,
    FileName character varying(50),
    Type integer,
    PRIMARY KEY (Seq, ParentSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
