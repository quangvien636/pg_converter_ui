-- ─── TABLE: SourceControl_DatabaseHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SourceControl_DatabaseHistory" (
    Id serial NOT NULL,
    UrlFile text NOT NULL,
    Description text NOT NULL,
    ProjectHistoryId integer NOT NULL,
    IsLastVersion boolean NOT NULL,
    CreateUserNo integer NOT NULL,
    CreateDate timestamp without time zone NOT NULL,
    UpdateUserNo integer,
    UpdateDate timestamp without time zone,
    Type integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
