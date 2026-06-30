-- ─── TABLE: DMake_ViewedLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_ViewedLog" (
    LogNo bigserial NOT NULL,
    ContentNo bigint DEFAULT 0,
    UserNo integer DEFAULT 0,
    ViewedDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
