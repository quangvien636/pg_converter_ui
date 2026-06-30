-- ─── TABLE: EAPPErpState ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPErpState" (
    EAErpStateCode integer NOT NULL PRIMARY KEY,
    ConvertCode character varying(10),
    sortord integer,
    "desc" character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
