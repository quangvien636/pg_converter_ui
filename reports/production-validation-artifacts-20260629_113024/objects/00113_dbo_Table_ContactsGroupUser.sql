-- ─── TABLE: ContactsGroupUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsGroupUser" (
    Seq serial NOT NULL,
    GroupNo integer,
    UserSeq integer,
    RegUserNo integer,
    RegDate timestamp without time zone DEFAULT now(),
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
