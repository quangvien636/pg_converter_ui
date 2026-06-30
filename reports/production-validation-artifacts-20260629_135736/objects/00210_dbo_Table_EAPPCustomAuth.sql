-- ─── TABLE: EAPPCustomAuth ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPCustomAuth" (
    ID bigserial NOT NULL,
    AuthType character varying(20),
    UserID character varying(50),
    DepartNo integer,
    FormID integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
