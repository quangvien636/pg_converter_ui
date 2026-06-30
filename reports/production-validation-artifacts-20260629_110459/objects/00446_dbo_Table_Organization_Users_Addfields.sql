-- ─── TABLE: Organization_Users_Addfields ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_Users_Addfields" (
    UserNo integer NOT NULL,
    UserID character varying(100) NOT NULL,
    Key character varying(100) NOT NULL,
    Value character varying(200) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
