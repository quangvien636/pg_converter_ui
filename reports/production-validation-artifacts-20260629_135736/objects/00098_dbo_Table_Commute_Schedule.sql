-- ─── TABLE: Commute_Schedule ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Commute_Schedule" (
    ScheduleNo serial NOT NULL,
    Title character varying(200) NOT NULL DEFAULT '',
    Contents text NOT NULL DEFAULT '',
    StartDate character varying(10) NOT NULL DEFAULT '',
    EndDate character varying(10) NOT NULL DEFAULT '',
    StartTime character varying(8) NOT NULL DEFAULT '',
    EndTime character varying(8) NOT NULL DEFAULT '',
    ShiftNo integer NOT NULL DEFAULT 0,
    UserNo integer NOT NULL DEFAULT 0,
    State integer NOT NULL DEFAULT 100,
    AppUserNo integer NOT NULL DEFAULT 0,
    AppDate timestamp without time zone,
    RegDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
