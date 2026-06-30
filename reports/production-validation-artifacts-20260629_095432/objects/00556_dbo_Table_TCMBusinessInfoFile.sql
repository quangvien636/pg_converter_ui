-- ─── TABLE: TCMBusinessInfoFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMBusinessInfoFile" (
    ID serial NOT NULL,
    BusinessID integer,
    FileName character varying(500),
    FileSize integer,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
