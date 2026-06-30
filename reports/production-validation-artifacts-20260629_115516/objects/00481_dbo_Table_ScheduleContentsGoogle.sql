-- ─── TABLE: ScheduleContentsGoogle ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsGoogle" (
    UserNo integer NOT NULL,
    ScheduleNo integer NOT NULL,
    GoogleEntryID character varying(500) NOT NULL,
    GoogleEntryUri character varying(500) NOT NULL,
    PRIMARY KEY (UserNo, ScheduleNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
