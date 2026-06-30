-- ─── TABLE: WorkToDo_ToDoList ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkToDo_ToDoList" (
    DataNo bigserial NOT NULL,
    ToDoNo integer NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Subject character varying(200) NOT NULL,
    Content text NOT NULL,
    FileCount integer NOT NULL,
    TypeNo integer NOT NULL,
    GroupNo integer NOT NULL,
    RepNo integer NOT NULL,
    StartDate timestamp without time zone,
    EndDate timestamp without time zone NOT NULL,
    ActualityEndDate timestamp without time zone,
    ProgressRate integer NOT NULL,
    Priority integer NOT NULL,
    State integer NOT NULL,
    StateModDate timestamp without time zone NOT NULL,
    Passed boolean NOT NULL,
    LatestJournalDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
