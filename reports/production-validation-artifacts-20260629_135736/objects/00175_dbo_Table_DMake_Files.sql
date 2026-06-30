-- ─── TABLE: DMake_Files ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Files" (
    FileNo bigserial NOT NULL,
    ContentNo bigint DEFAULT 0,
    FileName character varying(260) DEFAULT '',
    FileLength integer DEFAULT 0,
    FilePath character varying(1000) DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
