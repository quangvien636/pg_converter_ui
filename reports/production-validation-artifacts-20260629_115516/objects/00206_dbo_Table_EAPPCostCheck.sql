-- ─── TABLE: EAPPCostCheck ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCostCheck" (
    ID serial NOT NULL,
    Depart character varying(1000) NOT NULL DEFAULT '',
    Position character varying(1000) NOT NULL DEFAULT '',
    Grade character varying(1000) NOT NULL DEFAULT '',
    Userid character varying(1000) NOT NULL DEFAULT '',
    Name character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
