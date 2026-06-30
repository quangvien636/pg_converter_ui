-- ─── TABLE: EAPPReceiveSendMail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPReceiveSendMail" (
    id serial NOT NULL,
    SenderID character varying(50),
    SendTitle character varying(1000),
    ReceiverEmail character varying(8000),
    ReceiverName character varying(8000),
    ReceiveContent character varying(8000),
    SendState character(1) DEFAULT '0',
    Regdate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
