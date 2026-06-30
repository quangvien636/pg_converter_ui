-- ─── TABLE: WFAXFilter ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXFilter" (
    Seq integer NOT NULL PRIMARY KEY,
    UserId character varying(50),
    FieldFg character varying(4),
    ConditionFg character varying(4),
    ExecFg character varying(4),
    FaxBoxCd character varying(4),
    SortOrd integer,
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    DepartNo integer,
    ExecValue character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
