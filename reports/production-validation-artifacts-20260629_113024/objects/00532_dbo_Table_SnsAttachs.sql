-- ─── TABLE: SnsAttachs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsAttachs" (
    AttachNo serial NOT NULL,
    FileName character varying(260),
    FileType integer,
    MessageNo integer,
    GroupNo integer,
    FilePath character varying(1000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
