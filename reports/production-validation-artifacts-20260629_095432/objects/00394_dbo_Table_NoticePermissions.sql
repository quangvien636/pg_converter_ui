-- ─── TABLE: NoticePermissions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticePermissions" (
    Id serial NOT NULL,
    DeparNo integer,
    UserNo integer,
    PositionNo integer,
    ViewEndDate integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
