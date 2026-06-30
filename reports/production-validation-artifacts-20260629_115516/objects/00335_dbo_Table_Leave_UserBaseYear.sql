-- ─── TABLE: Leave_UserBaseYear ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Leave_UserBaseYear" (
    LeaveYear integer NOT NULL,
    UserNo integer NOT NULL,
    UserID character varying(50),
    YearOfService integer,
    LeaveMaxDays double precision,
    LeaveUseDays double precision,
    PrevUseDays double precision,
    StartDate date,
    EndDate date,
    PRIMARY KEY (LeaveYear, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
