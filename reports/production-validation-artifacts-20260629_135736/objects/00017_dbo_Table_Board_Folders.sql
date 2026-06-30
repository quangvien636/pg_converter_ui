-- ─── TABLE: Board_Folders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Folders" (
    FolderNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(4000),
    ParentNo integer NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL,
    LevelRand character varying(500),
    SpecType integer NOT NULL DEFAULT 1
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
