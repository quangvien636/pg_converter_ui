-- ─── INDEX: idx_eappprogress_manageridmanagestate ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappprogress_manageridmanagestate') THEN
        CREATE INDEX idx_eappprogress_manageridmanagestate ON public."EAPPProgress" (ManagerID, ManageState);
    END IF;
END;
$$;
