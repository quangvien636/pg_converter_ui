-- ─── TABLE: ScheduleCalendarType ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleCalendarType" (
    Id serial NOT NULL,
    Type integer NOT NULL,
    Name text,
    IsActive boolean NOT NULL DEFAULT true
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
