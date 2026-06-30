-- ─── TABLE: DMake_Folders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Folders" (
    FolderNo serial NOT NULL,
    Name character varying(100) DEFAULT '',
    Name_EN character varying(100) DEFAULT '',
    Name_JP character varying(100) DEFAULT '',
    Name_CH character varying(100) DEFAULT '',
    Name_VN character varying(100) DEFAULT '',
    ParentNo integer DEFAULT 0,
    SortNo integer DEFAULT 0,
    Enabled boolean DEFAULT true,
    RegUserNo integer DEFAULT 0,
    RegDate timestamp without time zone DEFAULT now(),
    ModUserNo integer DEFAULT 0,
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
