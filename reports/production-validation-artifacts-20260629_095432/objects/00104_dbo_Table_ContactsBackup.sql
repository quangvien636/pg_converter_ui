-- ─── TABLE: ContactsBackup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsBackup" (
    BackupNo serial NOT NULL,
    UserNo integer NOT NULL,
    ContactCnt integer NOT NULL,
    GroupCnt integer NOT NULL,
    Memo character varying(500) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    Path character varying(1000) NOT NULL,
    Type integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
