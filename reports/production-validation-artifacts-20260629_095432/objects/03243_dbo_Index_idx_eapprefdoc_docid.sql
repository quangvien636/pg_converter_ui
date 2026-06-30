-- ─── INDEX: idx_eapprefdoc_docid ON EAPPRefDoc ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eapprefdoc_docid') THEN
        CREATE INDEX idx_eapprefdoc_docid ON public."EAPPRefDoc" (DocID);
    END IF;
END;
$$;
