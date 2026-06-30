-- ─── TABLE: ScheduleContentsContacts ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsContacts" (
    ScheduleNo integer NOT NULL DEFAULT 0,
    UserSeq integer NOT NULL DEFAULT 0,
    GroupNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
