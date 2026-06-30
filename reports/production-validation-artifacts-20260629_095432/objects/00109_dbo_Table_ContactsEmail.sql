-- ─── TABLE: ContactsEmail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsEmail" (
    Seq serial NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Value character varying(50),
    IsDefault character(1),
    RegDate timestamp without time zone,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
