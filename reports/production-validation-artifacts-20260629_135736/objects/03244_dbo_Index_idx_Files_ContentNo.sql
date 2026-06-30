-- ─── INDEX: idx_files_contentno ON Board_Files ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_files_contentno') THEN
        CREATE INDEX idx_files_contentno ON public."Board_Files" (ContentNo);
    END IF;
END;
$$;
