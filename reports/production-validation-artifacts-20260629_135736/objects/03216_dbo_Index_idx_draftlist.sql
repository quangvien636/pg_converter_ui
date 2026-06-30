-- ─── INDEX: idx_draftlist ON EAPPDocument ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_draftlist') THEN
        CREATE INDEX idx_draftlist ON public."EAPPDocument" (WriterID, State, IsClose);
    END IF;
END;
$$;
