-- ─── TABLE: EDMSSerial ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSSerial" (
    ID serial NOT NULL,
    KeyCode character varying(100),
    Serial integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
