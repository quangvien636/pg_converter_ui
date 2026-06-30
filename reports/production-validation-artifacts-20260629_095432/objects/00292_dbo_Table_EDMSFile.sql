-- ─── TABLE: EDMSFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSFile" (
    ID serial NOT NULL,
    DOCID integer NOT NULL,
    ATTACHPATH character varying(500),
    ATTACHNAME character varying(250),
    ATTACHFlag character varying(10),
    IsPDF character(1),
    ContentId integer,
    Length bigint
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
