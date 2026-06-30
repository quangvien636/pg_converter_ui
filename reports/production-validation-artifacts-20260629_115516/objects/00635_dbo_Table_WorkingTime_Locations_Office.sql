-- ─── TABLE: WorkingTime_Locations_Office ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Locations_Office" (
    id serial NOT NULL,
    UserNo integer,
    LocationNo integer,
    DayCreate timestamp without time zone,
    IsWorking boolean,
    WorkTimeNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
