-- ─── INDEX: idx_eappoperation_docid ON EAPPOperation ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappoperation_docid') THEN
        CREATE INDEX idx_eappoperation_docid ON public."EAPPOperation" (DocID);
    END IF;
END;
$$;
