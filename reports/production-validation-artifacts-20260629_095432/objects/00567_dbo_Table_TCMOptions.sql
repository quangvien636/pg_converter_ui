-- ─── TABLE: TCMOptions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMOptions" (
    OptionKey character varying(50) NOT NULL PRIMARY KEY,
    OptionValue character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
