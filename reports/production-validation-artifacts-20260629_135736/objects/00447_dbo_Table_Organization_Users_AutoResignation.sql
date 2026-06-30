-- ─── TABLE: Organization_Users_AutoResignation ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_Users_AutoResignation" (
    No serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    UserNo integer NOT NULL,
    UserID character varying(100) NOT NULL,
    Name character varying(100) NOT NULL,
    DepartmentsName character varying(100) NOT NULL,
    PositionsName character varying(100) NOT NULL,
    DutiesName character varying(100) NOT NULL,
    Enabled boolean NOT NULL,
    AutoResignationDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
