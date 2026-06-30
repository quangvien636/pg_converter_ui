-- ─── TABLE: HNEWComment ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."HNEWComment" (
    ID serial NOT NULL,
    WriterID character varying(50) NOT NULL,
    DocId integer,
    RegDate timestamp without time zone,
    Comment character varying(4000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
