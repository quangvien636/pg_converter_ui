-- ─── TABLE: ScheduleToDosHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleToDosHistory" (
    HistoryNo serial NOT NULL,
    ToDoNo integer NOT NULL DEFAULT 0,
    HistoryType character varying(1) NOT NULL DEFAULT 'I',
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    RegUserNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
