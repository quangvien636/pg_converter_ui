-- ─── TABLE: SourceControl_Company ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SourceControl_Company" (
    Id serial NOT NULL,
    Name text NOT NULL,
    Code text,
    Website text,
    IpAddress text,
    Disable boolean NOT NULL,
    CreateUserNo integer NOT NULL,
    CreateDate timestamp without time zone NOT NULL,
    UpdateUserNo integer,
    UpdateDate timestamp without time zone,
    DatabaseType integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
