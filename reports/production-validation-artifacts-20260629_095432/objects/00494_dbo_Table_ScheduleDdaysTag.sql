-- ─── TABLE: ScheduleDdaysTag ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleDdaysTag" (
    UserNo integer NOT NULL,
    GroupNo integer NOT NULL,
    TagImageNo integer NOT NULL,
    PRIMARY KEY (UserNo, GroupNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
