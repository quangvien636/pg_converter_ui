-- ─── TABLE: ScheduleToDosOutlook ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleToDosOutlook" (
    UserNo integer NOT NULL,
    ToDoNo integer NOT NULL,
    OutlookEntryID character varying(500) NOT NULL DEFAULT '',
    PRIMARY KEY (UserNo, ToDoNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
