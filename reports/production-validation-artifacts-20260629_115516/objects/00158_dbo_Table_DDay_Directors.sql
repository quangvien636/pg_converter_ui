-- ─── TABLE: DDay_Directors ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_Directors" (
    DirectorNo bigserial NOT NULL,
    DayNo bigint,
    UserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
