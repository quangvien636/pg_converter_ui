-- ─── TABLE: Organization_Duties ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_Duties" (
    DutyNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Name_EN character varying(100) NOT NULL DEFAULT '',
    SortNo integer NOT NULL DEFAULT 1,
    Enabled boolean NOT NULL DEFAULT true,
    Name_CH character varying(200) NOT NULL DEFAULT '',
    Name_JP character varying(200) NOT NULL DEFAULT '',
    Name_VN character varying(200) NOT NULL DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
