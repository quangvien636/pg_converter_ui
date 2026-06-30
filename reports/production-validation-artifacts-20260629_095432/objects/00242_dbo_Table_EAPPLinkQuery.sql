-- ─── TABLE: EAPPLinkQuery ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPLinkQuery" (
    id serial NOT NULL,
    formid integer,
    Name character varying(100),
    eventstate integer,
    query text,
    connectionid integer,
    Regid character varying(50),
    RegDate timestamp without time zone,
    Modid character varying(50),
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
