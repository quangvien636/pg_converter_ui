-- ─── TABLE: WFAXUserGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXUserGroup" (
    UserGrpCd character(4) NOT NULL,
    UserId character varying(50) NOT NULL,
    UserGrpNm1 character varying(100) DEFAULT '',
    UserGrpNm2 character varying(100) DEFAULT '',
    UserGrpNm3 character varying(100) DEFAULT '',
    UserGrpNm4 character varying(100) DEFAULT '',
    FaxNum character varying(50) DEFAULT '',
    HFNum character varying(50) DEFAULT '',
    ParentUserGrpCd character(4) NOT NULL DEFAULT 0,
    SortOrd integer NOT NULL DEFAULT 0,
    UseYn character(1) NOT NULL DEFAULT 'Y',
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    PRIMARY KEY (UserGrpCd, UserId)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
