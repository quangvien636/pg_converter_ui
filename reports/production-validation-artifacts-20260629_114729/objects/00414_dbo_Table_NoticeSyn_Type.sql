-- ─── TABLE: NoticeSyn_Type ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_Type" (
    TypeNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Name_KO character varying(100) NOT NULL,
    Name_EN character varying(100) NOT NULL,
    Name_VN character varying(100) NOT NULL,
    Name_CH character varying(100) NOT NULL,
    Sort integer,
    Status integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
