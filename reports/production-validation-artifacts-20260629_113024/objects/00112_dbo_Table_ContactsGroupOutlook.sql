-- ─── TABLE: ContactsGroupOutlook ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsGroupOutlook" (
    UserNo integer NOT NULL,
    GroupNo integer NOT NULL,
    OutlookFolderEntryID character varying(500) NOT NULL DEFAULT '',
    PRIMARY KEY (UserNo, GroupNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
