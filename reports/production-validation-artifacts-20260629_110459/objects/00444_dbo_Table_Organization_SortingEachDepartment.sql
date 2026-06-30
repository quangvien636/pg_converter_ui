-- ─── TABLE: Organization_SortingEachDepartment ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_SortingEachDepartment" (
    DataNo bigserial NOT NULL,
    DepartNo integer NOT NULL,
    UserNo integer NOT NULL,
    SortNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
