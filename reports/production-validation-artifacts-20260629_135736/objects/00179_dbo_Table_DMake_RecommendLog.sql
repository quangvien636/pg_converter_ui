-- ─── TABLE: DMake_RecommendLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_RecommendLog" (
    LogNo serial NOT NULL,
    ContentNo bigint DEFAULT 0,
    UserNo integer DEFAULT 0,
    RecomendDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
