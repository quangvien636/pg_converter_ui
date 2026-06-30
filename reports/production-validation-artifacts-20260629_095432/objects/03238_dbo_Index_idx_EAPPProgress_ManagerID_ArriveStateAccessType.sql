-- ─── INDEX: idx_eappprogress_managerid_arrivestateaccesstype ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappprogress_managerid_arrivestateaccesstype') THEN
        CREATE INDEX idx_eappprogress_managerid_arrivestateaccesstype ON public."EAPPProgress" (ManagerID, ArriveState, AccessType);
    END IF;
END;
$$;
