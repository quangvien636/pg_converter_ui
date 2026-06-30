-- ─── TABLE: VOTEMaster ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTEMaster" (
    ID serial NOT NULL,
    Title character varying(500) NOT NULL,
    Type character varying(500) NOT NULL,
    PopUp character varying(1),
    StartDate character varying(10) NOT NULL,
    EndDate character varying(10) NOT NULL,
    Public character varying(1) NOT NULL,
    ItemCnt integer NOT NULL,
    IsStandBy smallint,
    IsReg smallint DEFAULT 1,
    IsOuterVote character(1),
    CompleteMessage character varying(1000),
    IsAnonyVote character(1) DEFAULT 'Y',
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
