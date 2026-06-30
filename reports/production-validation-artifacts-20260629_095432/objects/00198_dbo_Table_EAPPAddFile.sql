-- ─── TABLE: EAPPAddFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPAddFile" (
    ID serial NOT NULL,
    DocID integer NOT NULL,
    FilePath character varying(500) NOT NULL,
    FileName character varying(200) NOT NULL,
    RegUser character varying(20) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    Size bigint
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
