-- ─── TABLE: ContactsSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsSetup" (
    UserNo integer NOT NULL PRIMARY KEY,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    PageSize integer NOT NULL,
    StartContactBoxNo bigint,
    IsFolderExpanded boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
