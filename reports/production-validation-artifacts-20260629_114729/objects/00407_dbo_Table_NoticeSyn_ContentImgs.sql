-- ─── TABLE: NoticeSyn_ContentImgs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_ContentImgs" (
    ContentImgNo serial NOT NULL,
    NoticeNo integer NOT NULL,
    FileName character varying(200) NOT NULL,
    FileSize integer NOT NULL,
    Path character varying(500) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
