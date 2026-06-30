-- ─── TABLE: RegularWorkJournals ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."RegularWorkJournals" (
    JournalNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    GroupNo integer NOT NULL,
    CreationDate date NOT NULL,
    Title character varying(100) NOT NULL,
    DivisionNo integer NOT NULL,
    WorkTime integer NOT NULL,
    Content character varying(3000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
