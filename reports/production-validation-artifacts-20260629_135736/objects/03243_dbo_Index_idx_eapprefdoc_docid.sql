-- ─── INDEX: idx_eapprefdoc_docid ON EAPPRefDoc ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eapprefdoc_docid') THEN
        CREATE INDEX idx_eapprefdoc_docid ON public."EAPPRefDoc" (DocID);
    END IF;
END;
$$;
