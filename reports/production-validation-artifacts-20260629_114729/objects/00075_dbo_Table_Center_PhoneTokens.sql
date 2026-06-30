-- ─── TABLE: Center_PhoneTokens ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_PhoneTokens" (
    PhoneToken character varying(250) NOT NULL,
    SessionID character varying(250) NOT NULL,
    Domain character varying(250) NOT NULL,
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
