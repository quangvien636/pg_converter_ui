-- ─── TABLE: Commute_TimeShift ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Commute_TimeShift" (
    ShiftNo serial NOT NULL,
    ShiftName character varying(200) NOT NULL DEFAULT '',
    BackColor character varying(6) NOT NULL DEFAULT '',
    SortNo integer NOT NULL DEFAULT 0,
    StartTime character varying(8) NOT NULL DEFAULT '',
    EndTime character varying(8) NOT NULL DEFAULT '',
    UseYn character varying(1) NOT NULL DEFAULT 'N'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
