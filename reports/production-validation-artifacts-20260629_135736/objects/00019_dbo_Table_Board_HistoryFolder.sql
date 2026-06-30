-- ─── TABLE: Board_HistoryFolder ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_HistoryFolder" (
    HistoryFolderNo serial NOT NULL,
    UserNo integer NOT NULL,
    FolderNo integer NOT NULL,
    IsOpen boolean NOT NULL DEFAULT true
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
