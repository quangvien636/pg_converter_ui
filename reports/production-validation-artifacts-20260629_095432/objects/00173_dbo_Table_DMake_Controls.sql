-- ─── TABLE: DMake_Controls ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Controls" (
    ControlNo serial NOT NULL,
    Name character varying(100),
    Name_EN character varying(100),
    Name_JP character varying(100),
    Name_CH character varying(100),
    Name_VN character varying(100),
    ControlType character varying(1),
    Enabled boolean,
    IsFixedColumn boolean,
    ColumnName character varying(50),
    DataType character varying(50),
    FieldType character varying(5)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
