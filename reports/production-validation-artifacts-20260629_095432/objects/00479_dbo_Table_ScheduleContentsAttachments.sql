-- ─── TABLE: ScheduleContentsAttachments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsAttachments" (
    AttachNo serial NOT NULL,
    ScheduleNo integer NOT NULL,
    FileName character varying(260) NOT NULL,
    FileLength integer NOT NULL,
    FilePath character(500) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
