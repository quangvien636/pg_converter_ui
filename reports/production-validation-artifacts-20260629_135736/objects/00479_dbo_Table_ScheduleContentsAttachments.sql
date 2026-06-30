-- ─── TABLE: ScheduleContentsAttachments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsAttachments" (
    AttachNo serial NOT NULL,
    ScheduleNo integer NOT NULL DEFAULT 0,
    FileName character varying(260) NOT NULL DEFAULT '',
    FileLength integer NOT NULL DEFAULT 0,
    FilePath character(500) NOT NULL DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
