-- ─── TABLE: WFAXOption ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXOption" (
    OptionKey character varying(50) NOT NULL PRIMARY KEY,
    OptionVal character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
