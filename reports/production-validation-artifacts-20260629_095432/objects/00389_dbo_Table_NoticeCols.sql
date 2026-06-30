-- ─── TABLE: NoticeCols ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeCols" (
    Id serial NOT NULL,
    checkbox boolean NOT NULL,
    important boolean NOT NULL,
    category boolean NOT NULL,
    title boolean NOT NULL,
    writer boolean NOT NULL,
    WriteDate boolean NOT NULL,
    Hit boolean NOT NULL,
    NoticeDetp boolean NOT NULL,
    NoticeDetpShare boolean NOT NULL,
    NoticePeriod boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
