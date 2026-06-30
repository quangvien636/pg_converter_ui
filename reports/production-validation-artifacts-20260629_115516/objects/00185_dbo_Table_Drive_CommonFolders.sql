-- ─── TABLE: Drive_CommonFolders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Drive_CommonFolders" (
    CommonNo bigserial NOT NULL,
    FolderNo bigint NOT NULL,
    MaxLength bigint NOT NULL,
    PRIMARY KEY (CommonNo, FolderNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
