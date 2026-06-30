-- ─── TABLE: CMONConfiguration ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CMONConfiguration" (
    KeyCode character varying(200) NOT NULL,
    ValueData text,
    GroupCode character varying(10) NOT NULL,
    Description character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
