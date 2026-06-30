-- ─── TABLE: NoticeAttachments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeAttachments" (
    AttachNo serial NOT NULL,
    NoticeNo integer NOT NULL,
    FileName character varying(260) NOT NULL,
    FileLength bigint NOT NULL,
    FilePath character varying(500),
    Sort double precision
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
