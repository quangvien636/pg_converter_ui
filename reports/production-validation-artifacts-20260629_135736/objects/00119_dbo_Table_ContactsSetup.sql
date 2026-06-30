-- ─── TABLE: ContactsSetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsSetup" (
    UserNo integer NOT NULL PRIMARY KEY,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    RegUserNo integer NOT NULL DEFAULT 0,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer NOT NULL DEFAULT 0,
    PageSize integer NOT NULL DEFAULT 20,
    StartContactBoxNo bigint DEFAULT 1,
    IsFolderExpanded boolean DEFAULT true
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
