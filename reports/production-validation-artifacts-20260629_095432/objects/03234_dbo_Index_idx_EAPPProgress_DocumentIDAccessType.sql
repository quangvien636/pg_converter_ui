-- ─── INDEX: idx_eappprogress_documentidaccesstype ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappprogress_documentidaccesstype') THEN
        CREATE INDEX idx_eappprogress_documentidaccesstype ON public."EAPPProgress" (DocumentID, AccessType);
    END IF;
END;
$$;
