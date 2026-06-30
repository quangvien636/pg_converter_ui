-- ─── TABLE: Vacation_Requests ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Vacation_Requests" (
    RequestId serial NOT NULL,
    UserNo integer NOT NULL,
    TypeId integer NOT NULL,
    Fromd timestamp without time zone,
    Tod timestamp without time zone,
    VacationsCount double precision,
    Note character varying(4000),
    DateCreate timestamp without time zone,
    StatusUser integer,
    StatusAdmin integer,
    DateUpdate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
