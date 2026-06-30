-- ─── TABLE: EDMSEssential ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSEssential" (
    ID serial NOT NULL,
    EADocId integer,
    TITLE character varying(1000),
    KEYWORD character varying(200),
    SUMMARY text,
    VERSION character varying(50),
    ClassFlag character varying(2000),
    Sucurity character varying(2000),
    Sucuritylevel character varying(5),
    KeepDate character varying(5),
    OrgCD character varying(2000),
    Susin character varying(2000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
