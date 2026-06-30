-- ─── TABLE: SMSErrorMessage ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SMSErrorMessage" (
    LogID serial NOT NULL,
    UserNo integer,
    RegDate timestamp without time zone DEFAULT now(),
    Message character varying(2000) DEFAULT '',
    ErrorMessage character varying(1000) DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
