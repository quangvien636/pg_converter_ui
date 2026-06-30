-- ─── TABLE: NSFACompanyStaff ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFACompanyStaff" (
    Seq serial NOT NULL,
    CmSeq integer NOT NULL,
    CmName character varying(100),
    CmOrg character varying(100),
    CmPos character varying(100),
    CmTel character varying(100),
    CmMobile character varying(100),
    CmMail character varying(100),
    CmSex character varying(100),
    CmBirth character varying(100),
    CmRel character varying(100),
    CmMarr character varying(100),
    CmMarrMil character varying(100),
    CmHobby character varying(100),
    CmAddr character varying(100),
    CmCareer text,
    CmSchol text,
    CmFamily text,
    CmEtc text,
    CmWriter character varying(20),
    PRIMARY KEY (Seq, CmSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
