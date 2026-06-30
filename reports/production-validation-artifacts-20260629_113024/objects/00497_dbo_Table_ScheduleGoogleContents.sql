-- ─── TABLE: ScheduleGoogleContents ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleGoogleContents" (
    ScheduleNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    Title character varying(100) NOT NULL,
    StartDate timestamp without time zone NOT NULL,
    EndDate timestamp without time zone NOT NULL,
    ColorId character varying(20)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
