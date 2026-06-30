-- ─── TABLE: Leave_Options ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Leave_Options" (
    OptionKey character varying(50) NOT NULL PRIMARY KEY,
    OptionValue character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
