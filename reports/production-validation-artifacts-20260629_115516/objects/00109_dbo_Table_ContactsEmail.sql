-- ─── TABLE: ContactsEmail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsEmail" (
    Seq serial NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Value character varying(50),
    IsDefault character(1),
    RegDate timestamp without time zone DEFAULT now(),
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
