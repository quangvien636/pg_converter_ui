-- ─── TABLE: _TPRWkAbsEmp ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."_TPRWkAbsEmp" (
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
    AbsHour numeric(19,5),
    PRIMARY KEY (CompanySeq, AbsDate, EmpSeq, WkItemSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
