-- ─── TABLE: EDMSDocWriterInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSDocWriterInfo" (
    DocID integer NOT NULL PRIMARY KEY,
    DeptName character varying(50),
    DeptName_EN character varying(50),
    DeptName_CH character varying(50),
    DeptName_JP character varying(50),
    DeptName_VN character varying(50),
    PosName character varying(50),
    PosName_EN character varying(50),
    PosName_CH character varying(50),
    PosName_JP character varying(50),
    PosName_VN character varying(50),
    DutyName character varying(50),
    DutyName_EN character varying(50),
    DutyName_CH character varying(50),
    DutyName_JP character varying(50),
    DutyName_VN character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
