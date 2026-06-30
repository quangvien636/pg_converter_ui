-- ─── TABLE: SourceControl_CompanyHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SourceControl_CompanyHistory" (
    Id serial NOT NULL,
    CompanyId integer,
    ProjectHistoryId integer NOT NULL,
    IsLastVersion boolean NOT NULL,
    CreateUserNo integer NOT NULL,
    CreateDate timestamp without time zone NOT NULL,
    UpdateUserNo integer,
    UpdateDate timestamp without time zone,
    DatabaseHistoryId integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
