-- ─── TABLE: DMake_ViewedLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_ViewedLog" (
    LogNo bigserial NOT NULL,
    ContentNo bigint,
    UserNo integer,
    ViewedDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
