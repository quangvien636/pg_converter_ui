-- ─── TABLE: NSFAAuthUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NSFAAuthUsers" (
    UserId character varying(50) NOT NULL,
    DeptCode integer NOT NULL,
    AuthFg character varying(4),
    TeamAuthFg character varying(4),
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    PRIMARY KEY (UserId, DeptCode)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
