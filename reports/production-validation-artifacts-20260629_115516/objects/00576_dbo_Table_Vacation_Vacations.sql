-- ─── TABLE: Vacation_Vacations ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Vacation_Vacations" (
    VacationId serial NOT NULL,
    UserNo integer NOT NULL,
    Vacations double precision,
    Used double precision,
    Note character varying(4000),
    DateCreate timestamp without time zone,
    statusr integer,
    Memo character varying(500),
    years integer NOT NULL,
    PRIMARY KEY (UserNo, years)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
