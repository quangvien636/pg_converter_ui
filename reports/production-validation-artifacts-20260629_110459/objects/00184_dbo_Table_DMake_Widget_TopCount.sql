-- ─── TABLE: DMake_Widget_TopCount ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Widget_TopCount" (
    Type character varying(1) NOT NULL PRIMARY KEY,
    TopCount integer DEFAULT 5
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
