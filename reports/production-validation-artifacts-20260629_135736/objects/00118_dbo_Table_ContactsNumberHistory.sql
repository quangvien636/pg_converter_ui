-- ─── TABLE: ContactsNumberHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsNumberHistory" (
    HistoryNo integer NOT NULL,
    Seq integer NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Type smallint,
    TypeName character varying(50),
    Value character varying(50),
    IsDefault character(1),
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    PRIMARY KEY (HistoryNo, Seq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
