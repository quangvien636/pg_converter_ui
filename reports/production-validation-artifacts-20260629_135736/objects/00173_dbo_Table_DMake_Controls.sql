-- ─── TABLE: DMake_Controls ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Controls" (
    ControlNo serial NOT NULL,
    Name character varying(100) DEFAULT '',
    Name_EN character varying(100) DEFAULT '',
    Name_JP character varying(100) DEFAULT '',
    Name_CH character varying(100) DEFAULT '',
    Name_VN character varying(100) DEFAULT '',
    ControlType character varying(1) DEFAULT 'L',
    Enabled boolean DEFAULT true,
    IsFixedColumn boolean DEFAULT true,
    ColumnName character varying(50) DEFAULT '',
    DataType character varying(50) DEFAULT '',
    FieldType character varying(5) DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
