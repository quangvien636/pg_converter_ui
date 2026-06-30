-- ─── TABLE: ContactsUserOutlook ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsUserOutlook" (
    UserNo integer NOT NULL,
    Seq integer NOT NULL,
    OutlookEntryID character varying(500),
    PRIMARY KEY (UserNo, Seq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
