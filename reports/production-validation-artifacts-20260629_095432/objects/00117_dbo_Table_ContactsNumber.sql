-- ─── TABLE: ContactsNumber ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsNumber" (
    Seq serial NOT NULL,
    RegUserNo integer NOT NULL,
    UserSeq integer NOT NULL,
    Type smallint,
    TypeName character varying(50),
    Value character varying(50),
    IsDefault character(1),
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    SetCall integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
