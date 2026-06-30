-- ─── TABLE: ScheduleContentsOutlook ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsOutlook" (
    UserNo integer NOT NULL,
    ScheduleNo integer NOT NULL,
    OutlookEntryID character varying(500) NOT NULL DEFAULT '',
    PRIMARY KEY (UserNo, ScheduleNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
