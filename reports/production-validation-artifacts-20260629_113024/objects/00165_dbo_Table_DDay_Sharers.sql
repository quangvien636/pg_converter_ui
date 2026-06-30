-- ─── TABLE: DDay_Sharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_Sharers" (
    SharerNo bigserial NOT NULL,
    DayNo bigint NOT NULL,
    DepartNo integer NOT NULL,
    UserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
