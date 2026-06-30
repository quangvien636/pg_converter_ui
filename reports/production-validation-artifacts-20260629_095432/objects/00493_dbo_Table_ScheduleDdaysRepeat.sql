-- ─── TABLE: ScheduleDdaysRepeat ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaysRepeat" (
    DdayNo integer NOT NULL,
    RepeatDate date NOT NULL,
    CompleteDate date NOT NULL,
    IsComplete character(1) NOT NULL,
    PRIMARY KEY (DdayNo, RepeatDate)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
