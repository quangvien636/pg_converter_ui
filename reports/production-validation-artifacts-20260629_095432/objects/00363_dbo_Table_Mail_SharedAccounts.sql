-- ─── TABLE: Mail_SharedAccounts ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_SharedAccounts" (
    SharedAccountNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    SharedUserNo integer NOT NULL,
    DepartNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
