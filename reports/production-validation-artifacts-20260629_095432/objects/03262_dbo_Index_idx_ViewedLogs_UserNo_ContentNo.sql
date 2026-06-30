-- ─── INDEX: idx_viewedlogs_userno_contentno ON Board_ViewedLogs ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_viewedlogs_userno_contentno') THEN
        CREATE INDEX idx_viewedlogs_userno_contentno ON public."Board_ViewedLogs" (UserNo, ContentNo);
    END IF;
END;
$$;
