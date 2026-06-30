-- ─── INDEX: idx_approvallist ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_approvallist') THEN
        CREATE INDEX idx_approvallist ON public."EAPPProgress" (ManagerID, ArriveState, AccessType);
    END IF;
END;
$$;
