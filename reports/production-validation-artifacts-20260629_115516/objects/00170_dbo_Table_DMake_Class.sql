-- ─── TABLE: DMake_Class ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Class" (
    ClassNo serial NOT NULL,
    Name character varying(100) DEFAULT '',
    Name_EN character varying(100) DEFAULT '',
    Name_JP character varying(100) DEFAULT '',
    Name_CH character varying(100) DEFAULT '',
    Name_VN character varying(100) DEFAULT '',
    Enabled boolean DEFAULT true
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
