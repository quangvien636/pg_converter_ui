-- ─── TABLE: NSFAClaimInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFAClaimInfo" (
    Seq serial NOT NULL,
    CmSeq integer,
    CmName character varying(50),
    ClType1 character varying(50),
    ClType2 character varying(50),
    ClType3 character varying(50),
    ClClient character varying(50),
    ClWriter character varying(50),
    ClReDate character varying(50),
    ClCpDate character varying(50),
    ClFhDate character varying(50),
    ClRegDate character varying(50),
    ClCharge character varying(50),
    ClFlag character varying(50),
    ClSubject character varying(50),
    ClReContent text,
    ClFhContent text,
    ClFile1 character varying(50),
    ClFile2 character varying(50),
    ClFile3 character varying(50),
    ClFile4 character varying(50),
    ClFile5 character varying(50),
    ClFile6 character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
