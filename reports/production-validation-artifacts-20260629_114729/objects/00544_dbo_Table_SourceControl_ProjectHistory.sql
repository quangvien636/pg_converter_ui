-- ─── TABLE: SourceControl_ProjectHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SourceControl_ProjectHistory" (
    Id serial NOT NULL,
    Version text NOT NULL,
    Description text,
    ProjectId integer NOT NULL,
    IsLastVersion boolean NOT NULL DEFAULT true,
    CreateUserNo integer NOT NULL,
    CreateDate timestamp without time zone NOT NULL DEFAULT now(),
    UpdateUserNo integer,
    UpdateDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
