-- ─── TABLE: WorkingTime_Companies ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Companies" (
    CompanyNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    CreationDate timestamp without time zone NOT NULL,
    ConnectionString character varying(1000) NOT NULL,
    Name character varying(100) NOT NULL,
    Domain character varying(400) NOT NULL,
    State integer NOT NULL,
    hin integer,
    hout integer,
    miin integer,
    miout integer,
    timeofset integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
