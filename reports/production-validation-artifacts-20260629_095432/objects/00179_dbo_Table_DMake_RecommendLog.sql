-- ─── TABLE: DMake_RecommendLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_RecommendLog" (
    LogNo serial NOT NULL,
    ContentNo bigint,
    UserNo integer,
    RecomendDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
