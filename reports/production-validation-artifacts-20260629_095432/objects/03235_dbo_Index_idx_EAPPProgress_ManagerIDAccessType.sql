-- ─── INDEX: idx_eappprogress_manageridaccesstype ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappprogress_manageridaccesstype') THEN
        CREATE INDEX idx_eappprogress_manageridaccesstype ON public."EAPPProgress" (ManagerID, AccessType);
    END IF;
END;
$$;
