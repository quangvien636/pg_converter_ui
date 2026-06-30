-- ─── TABLE: EAPPCostMaster ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCostMaster" (
    ID serial NOT NULL,
    Name character varying(100),
    Regdate timestamp without time zone NOT NULL DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
