-- ─── TABLE: Vacation_SumRequests ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Vacation_SumRequests" (
    UserNo integer NOT NULL PRIMARY KEY,
    VacationsCount double precision,
    Note character varying(4000),
    DateCreate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
