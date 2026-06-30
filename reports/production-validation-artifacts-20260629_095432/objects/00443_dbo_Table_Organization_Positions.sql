-- ─── TABLE: Organization_Positions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_Positions" (
    PositionNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Name_EN character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL,
    Name_CH character varying(200) NOT NULL,
    Name_JP character varying(200) NOT NULL,
    Name_VN character varying(200) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
