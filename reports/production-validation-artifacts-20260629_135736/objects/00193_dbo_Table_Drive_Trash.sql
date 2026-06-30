-- ─── TABLE: Drive_Trash ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_Trash" (
    ItemNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DateDeleted timestamp without time zone NOT NULL,
    FullPath character varying(255) NOT NULL,
    FileNo bigint NOT NULL,
    FolderNo bigint NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
