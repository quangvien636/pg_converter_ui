-- ─── TABLE: Organization_Users_InfoAddfield_Sub ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_Users_InfoAddfield_Sub" (
    NoSub serial NOT NULL,
    UserNo integer NOT NULL,
    No integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Code character varying(100) NOT NULL,
    Name character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
