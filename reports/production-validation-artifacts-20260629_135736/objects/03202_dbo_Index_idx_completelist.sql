-- ─── INDEX: idx_completelist ON EAPPDocument ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_completelist') THEN
        CREATE INDEX idx_completelist ON public."EAPPDocument" (State, IsClose);
    END IF;
END;
$$;
