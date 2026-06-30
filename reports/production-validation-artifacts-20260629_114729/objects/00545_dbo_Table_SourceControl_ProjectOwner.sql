-- ─── TABLE: SourceControl_ProjectOwner ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SourceControl_ProjectOwner" (
    Id integer NOT NULL PRIMARY KEY,
    ProjectId integer NOT NULL,
    UserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
