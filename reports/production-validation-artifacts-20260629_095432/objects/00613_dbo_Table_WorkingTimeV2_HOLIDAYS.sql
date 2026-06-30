-- ─── TABLE: WorkingTimeV2_HOLIDAYS ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTimeV2_HOLIDAYS" (
    hNo serial NOT NULL,
    UserNo integer NOT NULL,
    TOT_HOLIDAYS double precision,
    USE_HOLIDAYS double precision,
    JAN_HOLIDAYS double precision,
    WORK_YEAR integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
