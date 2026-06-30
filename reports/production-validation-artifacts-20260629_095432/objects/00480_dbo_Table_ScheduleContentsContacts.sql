-- ─── TABLE: ScheduleContentsContacts ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsContacts" (
    ScheduleNo integer NOT NULL,
    UserSeq integer NOT NULL,
    GroupNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
