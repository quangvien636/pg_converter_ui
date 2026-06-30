-- ─── TABLE: ScheduleContentsHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleContentsHistory" (
    HistoryNo serial NOT NULL,
    ScheduleNo integer NOT NULL,
    HistoryType character varying(1) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
