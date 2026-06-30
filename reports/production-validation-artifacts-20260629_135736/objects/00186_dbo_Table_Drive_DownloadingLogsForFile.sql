-- ─── TABLE: Drive_DownloadingLogsForFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_DownloadingLogsForFile" (
    LogNo bigserial NOT NULL,
    FileNo bigint NOT NULL,
    UserNo integer NOT NULL,
    DateDownloaded timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
