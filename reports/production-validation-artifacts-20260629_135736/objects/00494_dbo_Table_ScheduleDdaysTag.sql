-- ─── TABLE: ScheduleDdaysTag ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaysTag" (
    UserNo integer NOT NULL DEFAULT 0,
    GroupNo integer NOT NULL DEFAULT 0,
    TagImageNo integer NOT NULL DEFAULT 0,
    PRIMARY KEY (UserNo, GroupNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
