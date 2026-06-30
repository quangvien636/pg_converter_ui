-- ─── TABLE: WorkingTime_Calculater ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Calculater" (
    Calculaterno serial NOT NULL,
    UserNo integer,
    WorkingDay integer,
    TimeCheckIn double precision,
    TimeCheckOut double precision,
    RegDate timestamp without time zone,
    TimeWork double precision,
    Type integer,
    WorkingNoRef integer,
    TimeLate integer,
    TimeOfset double precision,
    CheckIn timestamp without time zone,
    CheckOut timestamp without time zone,
    Status integer,
    typeOut integer,
    IsCheckIn integer,
    IsCheckOut integer,
    StatusOut integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
