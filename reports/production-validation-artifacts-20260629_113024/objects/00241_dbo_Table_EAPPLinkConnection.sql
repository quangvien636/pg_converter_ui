-- ─── TABLE: EAPPLinkConnection ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPLinkConnection" (
    id serial NOT NULL,
    Name character varying(100),
    provider character varying(20),
    ConnectionString text,
    Regid character varying(50),
    RegDate timestamp without time zone,
    Modid character varying(50),
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
