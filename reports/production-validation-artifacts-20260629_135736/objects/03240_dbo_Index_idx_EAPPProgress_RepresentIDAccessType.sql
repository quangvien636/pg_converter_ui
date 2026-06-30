-- ─── INDEX: idx_eappprogress_representidaccesstype ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappprogress_representidaccesstype') THEN
        CREATE INDEX idx_eappprogress_representidaccesstype ON public."EAPPProgress" (RepresentID, AccessType);
    END IF;
END;
$$;
