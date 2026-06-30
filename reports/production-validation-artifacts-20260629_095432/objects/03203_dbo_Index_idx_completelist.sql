-- ─── INDEX: idx_completelist ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_completelist') THEN
        CREATE INDEX idx_completelist ON public."EAPPProgress" (ManagerID, AccessType);
    END IF;
END;
$$;
