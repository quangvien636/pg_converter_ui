-- ─── TABLE: WorkingTimeV3_Vacations ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTimeV3_Vacations" (
    VacationId serial NOT NULL,
    UserNo integer NOT NULL,
    Vacations double precision,
    Overtime double precision,
    StartDate timestamp without time zone,
    EndDate timestamp without time zone,
    Note character varying(4000),
    status integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
