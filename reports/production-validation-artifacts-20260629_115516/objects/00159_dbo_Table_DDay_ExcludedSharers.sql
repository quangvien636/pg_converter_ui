-- ─── TABLE: DDay_ExcludedSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_ExcludedSharers" (
    DataNo bigserial NOT NULL,
    DayNo bigint NOT NULL,
    UserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
