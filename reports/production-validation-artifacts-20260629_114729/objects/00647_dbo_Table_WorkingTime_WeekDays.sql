-- ─── TABLE: WorkingTime_WeekDays ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_WeekDays" (
    ID integer NOT NULL PRIMARY KEY,
    Sun integer NOT NULL,
    Mon integer NOT NULL,
    Tue integer NOT NULL,
    Wen integer NOT NULL,
    Thur integer NOT NULL,
    Fri integer NOT NULL,
    Sat integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
