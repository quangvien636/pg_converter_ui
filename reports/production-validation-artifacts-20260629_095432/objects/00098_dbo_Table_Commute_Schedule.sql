-- ─── TABLE: Commute_Schedule ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Commute_Schedule" (
    ScheduleNo serial NOT NULL,
    Title character varying(200) NOT NULL,
    Contents text NOT NULL,
    StartDate character varying(10) NOT NULL,
    EndDate character varying(10) NOT NULL,
    StartTime character varying(8) NOT NULL,
    EndTime character varying(8) NOT NULL,
    ShiftNo integer NOT NULL,
    UserNo integer NOT NULL,
    State integer NOT NULL,
    AppUserNo integer NOT NULL,
    AppDate timestamp without time zone,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
