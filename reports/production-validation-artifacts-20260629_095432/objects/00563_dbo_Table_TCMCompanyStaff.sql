-- ─── TABLE: TCMCompanyStaff ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMCompanyStaff" (
    StaffID serial NOT NULL,
    CompanyID integer,
    StaffName character varying(100),
    StaffOrgan character varying(100),
    StaffPosition character varying(100),
    StaffTelNo character varying(50),
    StaffHpNo character varying(50),
    StaffMail character varying(100),
    StaffSex character(1),
    StaffBirth character varying(10),
    StaffReligion character varying(100),
    StaffMarriage character(1),
    StaffMarriageDate character varying(10),
    StaffHobby character varying(100),
    StaffAddr character varying(100),
    StaffCareer text,
    StaffEducation text,
    StaffFamily text,
    StaffMemo text,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
