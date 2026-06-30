-- ─── INDEX: idx_docid ON EAPPDocumentWBLD ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_docid') THEN
        CREATE INDEX idx_docid ON public."EAPPDocumentWBLD" (docid);
    END IF;
END;
$$;
