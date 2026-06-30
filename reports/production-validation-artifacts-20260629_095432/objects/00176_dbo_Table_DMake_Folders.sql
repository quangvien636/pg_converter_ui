-- ─── TABLE: DMake_Folders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Folders" (
    FolderNo serial NOT NULL,
    Name character varying(100),
    Name_EN character varying(100),
    Name_JP character varying(100),
    Name_CH character varying(100),
    Name_VN character varying(100),
    ParentNo integer,
    SortNo integer,
    Enabled boolean,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
