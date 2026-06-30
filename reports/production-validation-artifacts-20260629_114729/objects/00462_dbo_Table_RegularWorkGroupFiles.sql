-- ─── TABLE: RegularWorkGroupFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."RegularWorkGroupFiles" (
    FileNo bigint NOT NULL,
    HistoryNo integer NOT NULL,
    Name character varying(260) NOT NULL,
    Length integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
