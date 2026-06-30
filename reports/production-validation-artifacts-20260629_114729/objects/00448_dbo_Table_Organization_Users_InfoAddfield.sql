-- ─── TABLE: Organization_Users_InfoAddfield ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_Users_InfoAddfield" (
    No serial NOT NULL,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Code character varying(100) NOT NULL,
    Name character varying(100) NOT NULL,
    Type integer NOT NULL,
    SortNo integer NOT NULL,
    ModAuth boolean NOT NULL,
    Enabled boolean NOT NULL,
    DisPlay boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
