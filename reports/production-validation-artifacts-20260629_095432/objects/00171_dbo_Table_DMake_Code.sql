-- ─── TABLE: DMake_Code ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Code" (
    ClassNo integer NOT NULL,
    Code character varying(10) NOT NULL,
    Name character varying(100),
    Name_EN character varying(100),
    Name_JP character varying(100),
    Name_CH character varying(100),
    Name_VN character varying(100),
    SortNo integer,
    Enabled boolean,
    PRIMARY KEY (ClassNo, Code)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
