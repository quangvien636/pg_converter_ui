-- ─── TABLE: Drive_DownloadingLogsForFolder ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_DownloadingLogsForFolder" (
    LogNo bigserial NOT NULL,
    FolderNo bigint NOT NULL,
    UserNo integer NOT NULL,
    DateDownloaded timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
