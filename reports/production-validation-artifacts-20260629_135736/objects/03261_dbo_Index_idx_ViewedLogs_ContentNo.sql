-- ─── INDEX: idx_viewedlogs_contentno ON Board_ViewedLogs ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_viewedlogs_contentno') THEN
        CREATE INDEX idx_viewedlogs_contentno ON public."Board_ViewedLogs" (ContentNo);
    END IF;
END;
$$;
