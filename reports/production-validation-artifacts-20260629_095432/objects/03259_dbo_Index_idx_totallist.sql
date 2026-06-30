-- ─── INDEX: idx_totallist ON EAPPDocument ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_totallist') THEN
        CREATE INDEX idx_totallist ON public."EAPPDocument" (State, IsClose);
    END IF;
END;
$$;
