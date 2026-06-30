-- ─── TABLE: WFAXUserGroupOrgSet ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXUserGroupOrgSet" (
    Seq serial NOT NULL,
    UserGrpCd character(4),
    DepartNo integer,
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
