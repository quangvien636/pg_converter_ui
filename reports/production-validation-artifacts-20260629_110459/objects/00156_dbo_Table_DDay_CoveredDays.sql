-- ─── TABLE: DDay_CoveredDays ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_CoveredDays" (
    DataNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DayNo bigint NOT NULL,
    CoveredDate date NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
