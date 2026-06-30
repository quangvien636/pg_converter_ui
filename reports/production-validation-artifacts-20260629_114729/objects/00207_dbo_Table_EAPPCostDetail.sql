-- ─── TABLE: EAPPCostDetail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCostDetail" (
    ID serial NOT NULL,
    Masterid integer NOT NULL,
    FromCost bigint NOT NULL,
    ToCost bigint NOT NULL,
    Checkid integer NOT NULL,
    Regdate timestamp without time zone NOT NULL DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
