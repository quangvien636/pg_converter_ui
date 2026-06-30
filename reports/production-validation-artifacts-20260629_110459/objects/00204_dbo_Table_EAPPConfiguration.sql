-- ─── TABLE: EAPPConfiguration ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPConfiguration" (
    KeyCode character varying(20) NOT NULL PRIMARY KEY,
    ValueData character varying(2000),
    CodeGroup character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
