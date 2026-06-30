-- ─── TABLE: DDay_GroupInfoOfSharedDays ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_GroupInfoOfSharedDays" (
    InfoNo bigserial NOT NULL,
    DayNo bigint NOT NULL,
    UserNo integer NOT NULL,
    GroupNo bigint NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
