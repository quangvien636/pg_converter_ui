-- ─── TABLE: EAPPData ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPData" (
    DocID integer NOT NULL,
    Name character varying(50),
    Value character varying(500),
    PName character varying(50),
    Idx integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
