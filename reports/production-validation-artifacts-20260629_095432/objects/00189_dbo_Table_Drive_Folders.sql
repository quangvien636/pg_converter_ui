-- ─── TABLE: Drive_Folders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_Folders" (
    FolderNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DateCreated timestamp without time zone NOT NULL,
    DateModified timestamp without time zone NOT NULL,
    Name character varying(255) NOT NULL,
    Length bigint NOT NULL,
    ParentNo bigint NOT NULL,
    IsDeleted boolean NOT NULL,
    Sort double precision,
    Note character varying(500),
    PRIMARY KEY (FolderNo, UserNo, ParentNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
