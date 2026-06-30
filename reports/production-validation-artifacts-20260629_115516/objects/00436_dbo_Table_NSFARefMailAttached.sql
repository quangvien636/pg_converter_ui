-- ─── TABLE: NSFARefMailAttached ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFARefMailAttached" (
    Seq integer NOT NULL,
    FileSeq integer NOT NULL,
    FileNm character varying(500),
    FileSize integer,
    PRIMARY KEY (Seq, FileSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
