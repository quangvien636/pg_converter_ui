-- ─── TABLE: Drive_Files ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_Files" (
    FileNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DateCreated timestamp without time zone NOT NULL,
    DateModified timestamp without time zone NOT NULL,
    DateAccessed timestamp without time zone NOT NULL,
    Name character varying(255) NOT NULL,
    Length bigint NOT NULL,
    FolderNo bigint NOT NULL,
    IsDeleted boolean NOT NULL,
    Note character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
