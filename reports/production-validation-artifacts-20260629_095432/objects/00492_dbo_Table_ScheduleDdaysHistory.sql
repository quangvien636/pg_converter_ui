-- ─── TABLE: ScheduleDdaysHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaysHistory" (
    HistoryNo serial NOT NULL,
    DdayNo integer NOT NULL,
    HistoryType character varying(1) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
