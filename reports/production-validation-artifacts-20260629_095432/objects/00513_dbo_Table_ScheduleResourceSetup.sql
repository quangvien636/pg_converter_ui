-- ─── TABLE: ScheduleResourceSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceSetup" (
    UserNo integer NOT NULL PRIMARY KEY,
    ViewType integer NOT NULL,
    ViewCount integer NOT NULL,
    StartWeek integer NOT NULL,
    RsvnMethod integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    can integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
