-- ─── TABLE: BSLG_Master ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_Master" (
    ID serial NOT NULL,
    ATTDCont text,
    ATTDEtc character varying(500),
    SCHMCont text,
    SCHMEtc character varying(200),
    Content text,
    Content2 text,
    TagetID character varying(50),
    WriterID character varying(50) NOT NULL,
    RegDate character varying(10) NOT NULL,
    ModDate timestamp without time zone,
    att1 character varying(100),
    att2 character varying(100),
    att3 character varying(100),
    att4 character varying(100),
    att5 character varying(100),
    Status character(1) NOT NULL,
    PRIMARY KEY (WriterID, RegDate, Status)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
