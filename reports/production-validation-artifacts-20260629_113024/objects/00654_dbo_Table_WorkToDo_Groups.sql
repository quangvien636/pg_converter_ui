-- ─── TABLE: WorkToDo_Groups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkToDo_Groups" (
    GroupNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    ParentNo integer NOT NULL,
    RepNo integer NOT NULL,
    EndDate timestamp without time zone NOT NULL,
    Description character varying(500) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL,
    StartDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
