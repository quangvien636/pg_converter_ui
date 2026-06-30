-- ─── TABLE: WorkingTime_DateInsert ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_DateInsert" (
    DateInsert timestamp without time zone,
    DateInt integer NOT NULL,
    DAYOFWEEK integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
