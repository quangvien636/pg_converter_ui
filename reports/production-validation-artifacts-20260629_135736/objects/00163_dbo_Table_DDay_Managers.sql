-- ─── TABLE: DDay_Managers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_Managers" (
    ManagerNo bigserial NOT NULL,
    DayNo bigint NOT NULL,
    UserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
