-- ─── TABLE: WorkJournals ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkJournals" (
    JournalNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    WorkNo integer NOT NULL,
    CreationDate date NOT NULL,
    DivisionNo integer NOT NULL,
    WorkTime integer NOT NULL,
    CompletionRate integer NOT NULL,
    Content character varying(3000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
