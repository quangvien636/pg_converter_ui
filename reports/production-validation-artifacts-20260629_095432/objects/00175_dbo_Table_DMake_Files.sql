-- ─── TABLE: DMake_Files ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Files" (
    FileNo bigserial NOT NULL,
    ContentNo bigint,
    FileName character varying(260),
    FileLength integer,
    FilePath character varying(1000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
