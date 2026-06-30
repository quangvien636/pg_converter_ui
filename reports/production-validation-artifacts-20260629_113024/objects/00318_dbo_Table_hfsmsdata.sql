-- ─── TABLE: hfsmsdata ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."hfsmsdata" (
    intid serial NOT NULL,
    strsender_num character varying(20) NOT NULL,
    strreceiver_num character varying(20) NOT NULL,
    strsubject character varying(100),
    strmessage character varying(2000) NOT NULL,
    strkind character(1) NOT NULL DEFAULT 'a',
    intfiles integer DEFAULT 0,
    strfilenames character varying(256),
    intstate integer NOT NULL DEFAULT 0,
    strregdate character(19) NOT NULL,
    strreservedate character(19),
    strstarttime character(19),
    strendtime character(19),
    strsid character varying(30) NOT NULL,
    strcountrycode character varying(5) NOT NULL DEFAULT '82',
    strresultcode character(3),
    intuserno integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
