-- ─── TABLE: SourceControl_Project ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SourceControl_Project" (
    Id serial NOT NULL,
    Name text NOT NULL,
    Code text,
    Description text,
    CreateUserNo integer NOT NULL,
    CreateDate timestamp without time zone NOT NULL,
    UpdateUserNo integer,
    UpdateDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
