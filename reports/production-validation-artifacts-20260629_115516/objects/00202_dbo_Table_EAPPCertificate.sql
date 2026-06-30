-- ─── TABLE: EAPPCertificate ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCertificate" (
    ID serial NOT NULL,
    DocID integer NOT NULL,
    Kind character varying(50) NOT NULL,
    Macro1 character varying(100),
    Macro2 character varying(100),
    Macro3 character varying(100),
    Macro4 character varying(100),
    Macro5 character varying(100),
    Macro6 character varying(100),
    Macro7 character varying(100),
    Macro8 character varying(100),
    Macro9 character varying(100),
    Macro10 character varying(100),
    Content text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
