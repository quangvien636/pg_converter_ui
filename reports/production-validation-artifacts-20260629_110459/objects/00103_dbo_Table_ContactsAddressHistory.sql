-- ─── TABLE: ContactsAddressHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsAddressHistory" (
    HistoryNo integer NOT NULL,
    Seq integer NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Type smallint,
    TypeName character varying(50),
    ZipCode1 character varying(5),
    ZipCode2 character varying(5),
    Address character varying(500),
    IsDefault character(1),
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    PRIMARY KEY (HistoryNo, Seq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
