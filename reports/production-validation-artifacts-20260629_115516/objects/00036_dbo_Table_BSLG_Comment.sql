-- ─── TABLE: BSLG_Comment ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_Comment" (
    ID serial NOT NULL,
    Content character varying(4000),
    TargetID character varying(50),
    WriterID character varying(50),
    RegDate character varying(10),
    Status character varying(1),
    WriterDate character varying(50),
    orgcd character varying(4)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
