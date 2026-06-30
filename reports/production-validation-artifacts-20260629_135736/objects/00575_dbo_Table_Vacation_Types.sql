-- ─── TABLE: Vacation_Types ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Vacation_Types" (
    TypeId serial NOT NULL,
    UserNo integer NOT NULL,
    Name character varying(4000),
    Typei integer,
    Time integer,
    TimeDis double precision,
    DateCreate timestamp without time zone,
    statusr integer,
    Note character varying(4000),
    Sort double precision,
    OffType integer,
    special integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
