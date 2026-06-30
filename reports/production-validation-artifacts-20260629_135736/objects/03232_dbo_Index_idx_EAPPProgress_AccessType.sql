-- ─── INDEX: idx_eappprogress_accesstype ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappprogress_accesstype') THEN
        CREATE INDEX idx_eappprogress_accesstype ON public."EAPPProgress" (AccessType);
    END IF;
END;
$$;
