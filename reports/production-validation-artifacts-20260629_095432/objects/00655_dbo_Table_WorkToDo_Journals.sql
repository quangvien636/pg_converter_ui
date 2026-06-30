-- ─── TABLE: WorkToDo_Journals ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkToDo_Journals" (
    JournalNo bigserial NOT NULL,
    DataNo bigint NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    WriteDate timestamp without time zone NOT NULL,
    ProgressRate integer NOT NULL,
    WorkTime integer NOT NULL,
    Content text NOT NULL,
    TypeNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
