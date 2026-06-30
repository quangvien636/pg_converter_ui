-- ─── TABLE: EAPPDocUserSerial ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocUserSerial" (
    Id serial NOT NULL,
    DocId integer,
    ES01 character varying(30),
    ES02 character varying(30),
    SerialNum character varying(30),
    SaupjangName character varying(200),
    SaupjangCode character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
