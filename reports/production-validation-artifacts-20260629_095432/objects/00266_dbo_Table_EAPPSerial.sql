-- ─── TABLE: EAPPSerial ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPSerial" (
    ID serial NOT NULL,
    KeyCode character varying(100),
    Serial integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
