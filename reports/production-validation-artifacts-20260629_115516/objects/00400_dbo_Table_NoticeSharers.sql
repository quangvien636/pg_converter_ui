-- ─── TABLE: NoticeSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSharers" (
    NoticeNo integer NOT NULL,
    DepartNo integer NOT NULL,
    DepartName character varying(100),
    IsChild character(1),
    UserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
