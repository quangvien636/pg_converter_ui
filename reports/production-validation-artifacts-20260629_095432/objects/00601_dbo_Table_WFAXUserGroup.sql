-- ─── TABLE: WFAXUserGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXUserGroup" (
    UserGrpCd character(4) NOT NULL,
    UserId character varying(50) NOT NULL,
    UserGrpNm1 character varying(100),
    UserGrpNm2 character varying(100),
    UserGrpNm3 character varying(100),
    UserGrpNm4 character varying(100),
    FaxNum character varying(50),
    HFNum character varying(50),
    ParentUserGrpCd character(4) NOT NULL,
    SortOrd integer NOT NULL,
    UseYn character(1) NOT NULL,
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    PRIMARY KEY (UserGrpCd, UserId)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
