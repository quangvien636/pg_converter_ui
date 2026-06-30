-- ─── TABLE: Center_CompanyInformation ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_CompanyInformation" (
    InfoNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Key character varying(50) NOT NULL,
    Value text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
