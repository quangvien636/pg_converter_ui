-- ─── TABLE: EABuptleOption ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EABuptleOption" (
    KeyCode character varying(20) NOT NULL PRIMARY KEY,
    ValueData character varying(2000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
