-- ─── TABLE: ScheduleDdaysRepeat ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaysRepeat" (
    DdayNo integer NOT NULL,
    RepeatDate date NOT NULL DEFAULT now(),
    CompleteDate date NOT NULL DEFAULT now(),
    IsComplete character(1) NOT NULL DEFAULT 'N',
    PRIMARY KEY (DdayNo, RepeatDate)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
