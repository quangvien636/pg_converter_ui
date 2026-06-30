-- ─── INDEX: idx_historyfolder_userno_folderno ON Board_HistoryFolder ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_historyfolder_userno_folderno') THEN
        CREATE INDEX idx_historyfolder_userno_folderno ON public."Board_HistoryFolder" (UserNo, FolderNo);
    END IF;
END;
$$;
