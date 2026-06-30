-- ─── TABLE: Leave_Types ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Leave_Types" (
    LeaveNo serial NOT NULL,
    LeaveName character varying(50),
    IsPaid character varying(1),
    LeaveDays double precision,
    Remark character varying(50),
    Sort integer,
    UseYN character varying(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
