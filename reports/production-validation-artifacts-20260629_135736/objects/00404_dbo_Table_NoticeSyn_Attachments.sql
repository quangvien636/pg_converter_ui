-- ─── TABLE: NoticeSyn_Attachments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_Attachments" (
    AttachNo serial NOT NULL,
    NoticeNo integer NOT NULL,
    FileName character varying(260) NOT NULL,
    FileLength integer NOT NULL,
    FilePath character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
