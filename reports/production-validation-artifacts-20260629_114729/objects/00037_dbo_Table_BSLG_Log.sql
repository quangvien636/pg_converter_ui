-- ─── TABLE: BSLG_Log ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_Log" (
    UserID character varying(50) NOT NULL,
    RegDate character varying(8) NOT NULL,
    Content1 text,
    Content2 text,
    att1 character varying(100),
    att2 character varying(100),
    att3 character varying(100),
    att4 character varying(100),
    att5 character varying(100),
    Title character varying(100),
    Plot character varying(10),
    Orgcd character varying(4)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
