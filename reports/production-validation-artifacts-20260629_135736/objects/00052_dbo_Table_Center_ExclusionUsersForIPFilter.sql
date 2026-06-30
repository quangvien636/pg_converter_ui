-- ─── TABLE: Center_ExclusionUsersForIPFilter ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_ExclusionUsersForIPFilter" (
    ExclusionNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    Allow boolean NOT NULL,
    SortNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
