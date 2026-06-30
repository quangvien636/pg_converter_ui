-- ─── INDEX: idx_eappprogress_manageridarrivestate ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappprogress_manageridarrivestate') THEN
        CREATE INDEX idx_eappprogress_manageridarrivestate ON public."EAPPProgress" (ManagerID, ArriveState);
    END IF;
END;
$$;
