-- ─── TABLE: WorkingTime_Times_v2 ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Times_v2" (
    WorkingNo integer NOT NULL PRIMARY KEY,
    WorkingDayOfCompany integer,
    CheckDateTimeOffset timestamp with time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
