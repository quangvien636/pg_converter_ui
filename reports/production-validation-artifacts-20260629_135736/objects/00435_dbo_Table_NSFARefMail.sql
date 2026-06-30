-- ─── TABLE: NSFARefMail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFARefMail" (
    SEQ serial NOT NULL,
    OriSeq integer,
    RegUserId character varying(50),
    RegName character varying(50),
    FromName character varying(50),
    FromAddr character varying(100),
    ToAddr text,
    Title character varying(1000),
    Cc text,
    Bcc text,
    Content text,
    InsideYn character(1),
    FromSeq integer,
    EmlFileNm character varying(500),
    MsgUid character varying(500),
    RecSendDate timestamp without time zone,
    FileCnt integer,
    ToDomain character varying(100),
    Email character varying(100),
    ScheSendYn character varying(1),
    ErrMsg character varying(1000),
    MsgSize integer,
    Pop3Yn character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
