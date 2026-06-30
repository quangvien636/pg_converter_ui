-- ─── TABLE: BSLG_WLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_WLog" (
    UserID character varying(50) NOT NULL,
    RegDate character varying(8) NOT NULL,
    Content text,
    att1 character varying(50),
    att2 character varying(50),
    att3 character varying(50),
    att4 character varying(50),
    att5 character varying(50),
    PRIMARY KEY (UserID, RegDate)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
