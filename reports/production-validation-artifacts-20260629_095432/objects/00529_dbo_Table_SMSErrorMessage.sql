-- ─── TABLE: SMSErrorMessage ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SMSErrorMessage" (
    LogID serial NOT NULL,
    UserNo integer,
    RegDate timestamp without time zone,
    Message character varying(2000),
    ErrorMessage character varying(1000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
