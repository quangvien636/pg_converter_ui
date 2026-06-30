-- ─── INDEX: idx_eappdocument_isclosestate ON EAPPDocument ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappdocument_isclosestate') THEN
        CREATE INDEX idx_eappdocument_isclosestate ON public."EAPPDocument" (IsClose, State);
    END IF;
END;
$$;
