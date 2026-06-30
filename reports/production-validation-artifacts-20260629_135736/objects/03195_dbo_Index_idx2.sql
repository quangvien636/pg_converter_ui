-- ─── INDEX: idx2 ON EDMSDocFolder ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx2') THEN
        CREATE INDEX idx2 ON public."EDMSDocFolder" (FolderID);
    END IF;
END;
$$;
