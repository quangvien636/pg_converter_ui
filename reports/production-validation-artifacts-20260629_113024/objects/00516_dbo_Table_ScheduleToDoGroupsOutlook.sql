-- ─── TABLE: ScheduleToDoGroupsOutlook ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleToDoGroupsOutlook" (
    UserNo integer NOT NULL,
    GroupNo integer NOT NULL,
    FolderEntryID character varying(500) NOT NULL DEFAULT '',
    PRIMARY KEY (UserNo, GroupNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
