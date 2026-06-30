-- ─── TABLE: DDay_CountOfAppBadge ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_CountOfAppBadge" (
    UserNo integer NOT NULL PRIMARY KEY,
    BadgeCount integer NOT NULL,
    ListOfDays text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
