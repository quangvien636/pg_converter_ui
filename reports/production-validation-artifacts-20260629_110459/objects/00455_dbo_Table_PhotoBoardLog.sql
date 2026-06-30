-- ─── TABLE: PhotoBoardLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."PhotoBoardLog" (
    seq serial NOT NULL,
    ParentID integer NOT NULL,
    ViewerID character varying(50) NOT NULL,
    ViewTime timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
