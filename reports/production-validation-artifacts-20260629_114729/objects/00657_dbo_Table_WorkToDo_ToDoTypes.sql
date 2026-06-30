-- ─── TABLE: WorkToDo_ToDoTypes ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkToDo_ToDoTypes" (
    TypeNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Title character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
