-- ─── INDEX: idx_messageno ON CrewChat_CheckMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_messageno') THEN
        CREATE INDEX idx_messageno ON public."CrewChat_CheckMessage" (MessageNo);
    END IF;
END;
$$;
