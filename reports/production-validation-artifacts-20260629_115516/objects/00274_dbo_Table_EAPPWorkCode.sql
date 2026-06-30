-- ─── TABLE: EAPPWorkCode ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPWorkCode" (
    Code text,
    Name text,
    ParentCd text,
    Depth character varying(255)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
