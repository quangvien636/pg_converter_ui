-- ─── TABLE: EAPPCostCheck ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCostCheck" (
    ID serial NOT NULL,
    Depart character varying(1000) NOT NULL,
    Position character varying(1000) NOT NULL,
    Grade character varying(1000) NOT NULL,
    Userid character varying(1000) NOT NULL,
    Name character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
