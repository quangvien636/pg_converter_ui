-- ─── TABLE: hfsenddata ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."hfsenddata" (
    intid serial NOT NULL,
    strsender_faxnum character varying(20) NOT NULL,
    strreceiver_faxnum character varying(20) NOT NULL,
    strsubject character varying(100),
    intconvtif integer NOT NULL DEFAULT 1,
    strfilenames character varying(800) NOT NULL,
    intfiles integer NOT NULL DEFAULT 1,
    strtifnames character varying(800),
    intpages integer,
    intsentpages integer,
    intstate integer NOT NULL DEFAULT 0,
    strregdate character(19) NOT NULL,
    strreservedate character(19),
    strstarttime character(19),
    strendtime character(19),
    strsid character varying(30) NOT NULL,
    strcountrycode character varying(5) NOT NULL DEFAULT '82',
    intdeleted integer NOT NULL DEFAULT 0,
    strresultcode character(3),
    retrycnt integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
