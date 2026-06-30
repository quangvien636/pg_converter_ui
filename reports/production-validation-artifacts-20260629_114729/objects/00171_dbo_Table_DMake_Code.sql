-- ─── TABLE: DMake_Code ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Code" (
    ClassNo integer NOT NULL,
    Code character varying(10) NOT NULL DEFAULT '',
    Name character varying(100) DEFAULT '',
    Name_EN character varying(100) DEFAULT '',
    Name_JP character varying(100) DEFAULT '',
    Name_CH character varying(100) DEFAULT '',
    Name_VN character varying(100) DEFAULT '',
    SortNo integer DEFAULT 1,
    Enabled boolean DEFAULT true,
    PRIMARY KEY (ClassNo, Code)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
