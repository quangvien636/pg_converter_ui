-- ─── TABLE: BSLG_OrgLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."BSLG_OrgLog" (
    DepartID character varying(4) NOT NULL,
    RegDate character varying(8) NOT NULL,
    SLog text,
    ELog text,
    att1 character varying(50),
    att2 character varying(50),
    att3 character varying(50),
    att4 character varying(50),
    att5 character varying(50),
    PRIMARY KEY (DepartID, RegDate)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
