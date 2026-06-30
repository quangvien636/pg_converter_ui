-- ─── TABLE: ScheduleDdaysHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaysHistory" (
    HistoryNo serial NOT NULL,
    DdayNo integer NOT NULL,
    HistoryType character varying(1) NOT NULL DEFAULT '',
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    RegUserNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
