-- ─── TABLE: RegularWorkJournalDivisions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."RegularWorkJournalDivisions" (
    DivisionNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    ParentNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
