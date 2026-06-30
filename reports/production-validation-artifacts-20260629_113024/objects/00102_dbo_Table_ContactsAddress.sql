-- ─── TABLE: ContactsAddress ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsAddress" (
    Seq serial NOT NULL,
    RegUserNo integer NOT NULL,
    UserSeq integer NOT NULL,
    Type smallint,
    TypeName character varying(50),
    ZipCode1 character varying(5),
    ZipCode2 character varying(5),
    Address character varying(500),
    IsDefault character(1),
    RegDate timestamp without time zone DEFAULT now(),
    ModDate timestamp without time zone DEFAULT now(),
    Latitude double precision,
    Longitude double precision
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
