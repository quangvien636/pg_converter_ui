-- ─── TABLE: PhotoBoardCmt ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."PhotoBoardCmt" (
    ID serial NOT NULL,
    ParentID integer NOT NULL,
    WriterID character varying(50) NOT NULL,
    Comment character varying(2048) NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
