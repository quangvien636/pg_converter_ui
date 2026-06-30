-- ─── TABLE: Leave_Types ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Leave_Types" (
    LeaveNo serial NOT NULL,
    LeaveName character varying(50) DEFAULT '',
    IsPaid character varying(1) DEFAULT 'P',
    LeaveDays double precision DEFAULT 1,
    Remark character varying(50) DEFAULT '',
    Sort integer,
    UseYN character varying(1) DEFAULT 'Y'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
