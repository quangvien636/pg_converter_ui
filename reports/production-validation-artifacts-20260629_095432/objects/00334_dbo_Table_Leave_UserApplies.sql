-- ─── TABLE: Leave_UserApplies ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Leave_UserApplies" (
    ApplyNo serial NOT NULL,
    UserNo integer,
    UserID character varying(50),
    LeaveYear integer,
    LeaveTypeNo integer,
    FromDate date,
    ToDate date,
    LeaveDaysTotal double precision,
    Reason character varying(100),
    ApprovalYN character varying(1),
    EappID integer,
    ApprovalUserID character varying(50),
    ApprovalDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
