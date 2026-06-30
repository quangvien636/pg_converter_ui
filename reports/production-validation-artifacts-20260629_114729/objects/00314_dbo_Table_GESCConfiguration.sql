-- ─── TABLE: GESCConfiguration ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."GESCConfiguration" (
    KeyCode character varying(30),
    ValueData character varying(2000),
    CodeGroup character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
