-- ─── TABLE: DMake_Shares ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Shares" (
    ShareNo bigserial NOT NULL,
    ContentNo bigint,
    UserNo integer,
    DepartNo integer,
    IsChild boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
