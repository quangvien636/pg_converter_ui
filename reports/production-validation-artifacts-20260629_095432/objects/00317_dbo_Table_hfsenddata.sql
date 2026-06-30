-- ─── TABLE: hfsenddata ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."hfsenddata" (
    intid serial NOT NULL,
    strsender_faxnum character varying(20) NOT NULL,
    strreceiver_faxnum character varying(20) NOT NULL,
    strsubject character varying(100),
    intconvtif integer NOT NULL,
    strfilenames character varying(800) NOT NULL,
    intfiles integer NOT NULL,
    strtifnames character varying(800),
    intpages integer,
    intsentpages integer,
    intstate integer NOT NULL,
    strregdate character(19) NOT NULL,
    strreservedate character(19),
    strstarttime character(19),
    strendtime character(19),
    strsid character varying(30) NOT NULL,
    strcountrycode character varying(5) NOT NULL,
    intdeleted integer NOT NULL,
    strresultcode character(3),
    retrycnt integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
