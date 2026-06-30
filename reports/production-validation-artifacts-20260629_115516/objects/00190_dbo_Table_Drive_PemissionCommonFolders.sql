-- ─── TABLE: Drive_PemissionCommonFolders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_PemissionCommonFolders" (
    SharingNo bigserial NOT NULL,
    FolderNo bigint NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    PRIMARY KEY (SharingNo, FolderNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
