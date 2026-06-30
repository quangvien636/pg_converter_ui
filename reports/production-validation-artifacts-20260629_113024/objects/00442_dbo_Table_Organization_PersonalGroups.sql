-- ─── TABLE: Organization_PersonalGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_PersonalGroups" (
    GroupNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    ListOfUsers text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
