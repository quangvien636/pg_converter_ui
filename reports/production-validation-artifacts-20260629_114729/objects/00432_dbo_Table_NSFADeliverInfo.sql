-- ─── TABLE: NSFADeliverInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFADeliverInfo" (
    Seq serial NOT NULL,
    CmSeq integer NOT NULL,
    CmName character varying(50),
    DlInstDate character varying(50),
    DlName character varying(50),
    DlVer character varying(50),
    DlStaff character varying(50),
    DlTel character varying(50),
    DlMobile character varying(50),
    DlEMail character varying(50),
    DlChage character varying(50),
    DlFhDate character varying(50),
    DlID character varying(50),
    DlPWD character varying(50),
    DlContent1 text,
    DlContent2 text,
    DlContent3 text,
    DlContent4 text,
    DlContent5 text,
    DlContent6 text,
    PRIMARY KEY (Seq, CmSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
