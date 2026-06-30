-- ─── TABLE: hfreceivedata ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."hfreceivedata" (
    intid serial NOT NULL,
    strsender_faxnum character varying(20) NOT NULL,
    strreceiver_faxnum character varying(20) NOT NULL,
    strsubject character varying(100),
    strfilename character varying(100) NOT NULL,
    intfilesize integer NOT NULL,
    intpages integer NOT NULL,
    strreceivedate character(19) NOT NULL,
    intstate integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
