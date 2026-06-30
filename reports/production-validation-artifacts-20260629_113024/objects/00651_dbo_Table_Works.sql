-- ─── TABLE: Works ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Works" (
    WorkNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    GroupNo integer NOT NULL,
    HistoryNo integer NOT NULL,
    CompletionRate integer NOT NULL,
    FinalDate date,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
