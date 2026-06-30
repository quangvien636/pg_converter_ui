-- ─── TABLE: WFAXBoxJoint ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXBoxJoint" (
    FaxBoxCd character varying(4) NOT NULL,
    UserId character varying(50) NOT NULL,
    FaxBoxNm1 character varying(100),
    FaxBoxNm2 character varying(100),
    FaxBoxNm3 character varying(100),
    FaxBoxNm4 character varying(100),
    ParentFaxBoxCd character varying(4),
    SortOrd integer,
    UseYn character varying(1),
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    PRIMARY KEY (FaxBoxCd, UserId)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
