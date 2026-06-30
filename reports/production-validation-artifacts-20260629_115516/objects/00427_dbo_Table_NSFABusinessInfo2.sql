-- ─── TABLE: NSFABusinessInfo2 ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFABusinessInfo2" (
    Seq integer NOT NULL,
    CmSeq integer NOT NULL,
    Writer character varying(20),
    WriteName character varying(50),
    BsDate character varying(20),
    BsType1 character varying(50),
    BsType2 character varying(50),
    BsClient character varying(50),
    BsMoney character varying(50),
    BsContent text,
    FileNames character varying(200),
    FileSizes character varying(200),
    BsSubject character varying(200),
    BsNDate character varying(20),
    BsSalsDate character varying(50),
    BsSalsCont character varying(500),
    BsRegDate character varying(50) NOT NULL,
    NextDate character varying(20),
    NextAct character varying(200),
    NextActYn character varying(1),
    ApprovalSeq character varying(4000),
    MailSeq character varying(4000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
