-- ─── TABLE: Vacation_RequestEps ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Vacation_RequestEps" (
    RequestId serial NOT NULL,
    TypeId integer NOT NULL,
    Fromd timestamp without time zone,
    Tod timestamp without time zone,
    Note character varying(4000),
    DateCreate timestamp without time zone,
    StatusUser integer,
    StatusAdmin integer,
    TypeForAll integer,
    TimeDis double precision,
    UserNo character varying(500),
    departno character varying(500),
    UsernoI integer,
    VacationsCount integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
