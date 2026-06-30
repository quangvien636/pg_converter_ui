-- ─── TABLE: Main_UserSettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_UserSettings" (
    UserNo integer NOT NULL PRIMARY KEY,
    UseCustomDashBoard boolean NOT NULL,
    DashBoardDisplayOrder character varying(1000) NOT NULL,
    IsDashBoardChangeNotification boolean NOT NULL,
    FirstProjectCode character varying(100) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
