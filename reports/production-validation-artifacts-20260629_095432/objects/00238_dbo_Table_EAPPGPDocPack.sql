-- ─── TABLE: EAPPGPDocPack ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPGPDocPack" (
    seq serial NOT NULL,
    eadocid integer,
    mode character varying(10),
    senderorgcode character varying(10),
    senderid character varying(10),
    sendname character varying(200),
    receiveid character varying(1000),
    receivename character varying(2000),
    date timestamp without time zone,
    title character varying(300),
    docid character varying(100),
    doctype_type character varying(100),
    doctype_name character varying(100),
    doctype_dept character varying(20),
    sendgw character varying(50),
    dtdversion character varying(10),
    xslversion character varying(10),
    packxmlfilename character(34),
    isdelete character(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
