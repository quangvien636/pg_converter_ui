-- ─── TABLE: NSFABusiNegativeInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFABusiNegativeInfo" (
    Seq serial NOT NULL,
    CmSeq integer NOT NULL,
    AuthFlag character varying(8000),
    AuthName character varying(4000),
    Writer character varying(50),
    Content text,
    RegDate character varying(50),
    PRIMARY KEY (Seq, CmSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
