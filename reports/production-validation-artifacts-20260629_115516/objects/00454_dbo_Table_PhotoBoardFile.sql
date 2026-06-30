-- ─── TABLE: PhotoBoardFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."PhotoBoardFile" (
    seq serial NOT NULL,
    ParentID integer NOT NULL,
    FileName character varying(512),
    FirstFlag boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
