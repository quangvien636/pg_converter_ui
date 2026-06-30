-- ─── TABLE: ContactsGroupUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsGroupUser" (
    Seq serial NOT NULL,
    GroupNo integer,
    UserSeq integer,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
