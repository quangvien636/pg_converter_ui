-- ─── TABLE: ScheduleToDosHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleToDosHistory" (
    HistoryNo serial NOT NULL,
    ToDoNo integer NOT NULL,
    HistoryType character varying(1) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
