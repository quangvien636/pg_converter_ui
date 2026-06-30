-- ─── TABLE: _TPRWkAbsEmp_taekyung ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."_TPRWkAbsEmp_taekyung" (
    CompanySeq integer NOT NULL,
    AbsDate character(8) NOT NULL,
    EmpSeq integer NOT NULL,
    WkItemSeq integer NOT NULL,
    IsHalf character(1),
    Remark character varying(200),
    CCSeq integer,
    SMInputType integer,
    UMGrpSeq integer,
    UMWkGrpSeq integer,
    Seq integer,
    LastUserSeq integer,
    LastDateTime timestamp without time zone,
    empno character(8) NOT NULL,
    docno integer NOT NULL,
    flag character(1) NOT NULL,
    IsCancel character(1) NOT NULL,
    PRIMARY KEY (CompanySeq, AbsDate, EmpSeq, WkItemSeq, IsCancel)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
