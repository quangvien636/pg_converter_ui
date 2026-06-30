-- ─── TABLE: Commute_TimeShift ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Commute_TimeShift" (
    ShiftNo serial NOT NULL,
    ShiftName character varying(200) NOT NULL,
    BackColor character varying(6) NOT NULL,
    SortNo integer NOT NULL,
    StartTime character varying(8) NOT NULL,
    EndTime character varying(8) NOT NULL,
    UseYn character varying(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
