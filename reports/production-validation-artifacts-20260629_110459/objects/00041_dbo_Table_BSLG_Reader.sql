-- ─── TABLE: BSLG_Reader ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_Reader" (
    RegId character varying(50) NOT NULL,
    ReaderId character varying(50) NOT NULL,
    RegDate character varying(8),
    ReadDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
