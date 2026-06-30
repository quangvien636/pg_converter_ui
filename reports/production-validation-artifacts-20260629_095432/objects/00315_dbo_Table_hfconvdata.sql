-- ─── TABLE: hfconvdata ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."hfconvdata" (
    intid serial NOT NULL,
    strfilenames character varying(800) NOT NULL,
    intfiles integer NOT NULL,
    strtifnames character varying(800),
    intpages integer,
    intstate integer NOT NULL,
    strregdate character(19) NOT NULL,
    strsid character varying(30) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
