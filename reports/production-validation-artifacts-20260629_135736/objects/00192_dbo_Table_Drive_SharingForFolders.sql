-- ─── TABLE: Drive_SharingForFolders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_SharingForFolders" (
    SharingNo bigserial NOT NULL,
    FolderNo bigint NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
