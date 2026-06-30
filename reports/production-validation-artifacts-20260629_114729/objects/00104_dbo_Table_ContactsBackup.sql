-- ─── TABLE: ContactsBackup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsBackup" (
    BackupNo serial NOT NULL,
    UserNo integer NOT NULL,
    ContactCnt integer NOT NULL DEFAULT 0,
    GroupCnt integer NOT NULL DEFAULT 0,
    Memo character varying(500) NOT NULL DEFAULT '',
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    Path character varying(1000) NOT NULL,
    Type integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
