-- ─── INDEX: idx_eappfile_docid ON EAPPFile ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappfile_docid') THEN
        CREATE INDEX idx_eappfile_docid ON public."EAPPFile" (DocID);
    END IF;
END;
$$;
