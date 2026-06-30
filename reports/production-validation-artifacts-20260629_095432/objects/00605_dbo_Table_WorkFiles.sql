-- ─── TABLE: WorkFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkFiles" (
    FileNo bigserial NOT NULL,
    HistoryNo integer NOT NULL,
    Name character varying(260) NOT NULL,
    Length integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
