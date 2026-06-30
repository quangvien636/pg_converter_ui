-- ─── TABLE: EAPPCMONOrgan ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCMONOrgan" (
    DepartNo integer NOT NULL PRIMARY KEY,
    EACode character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
