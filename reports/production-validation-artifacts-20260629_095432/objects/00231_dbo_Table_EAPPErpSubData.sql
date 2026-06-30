-- ─── TABLE: EAPPErpSubData ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPErpSubData" (
    id serial NOT NULL,
    docid integer,
    SlipNo character varying(100),
    SlipAmount numeric(18,0),
    SlipDate character varying(20)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
