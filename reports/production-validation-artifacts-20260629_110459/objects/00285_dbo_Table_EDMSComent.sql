-- ─── TABLE: EDMSComent ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSComent" (
    ID serial NOT NULL,
    DocId integer,
    Coment character varying(4000),
    Writer character varying(50),
    WriteDate timestamp without time zone,
    Modifier character varying(50),
    ModiDate timestamp without time zone,
    isDelete character(1),
    OrgCd character varying(4)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
