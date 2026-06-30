-- ─── TABLE: ScheduleUserGoogleTokens ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleUserGoogleTokens" (
    Id serial NOT NULL,
    UNo integer,
    TokenData text NOT NULL,
    LastUpdated timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
