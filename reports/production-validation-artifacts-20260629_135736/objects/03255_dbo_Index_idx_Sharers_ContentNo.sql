-- ─── INDEX: idx_sharers_contentno ON Board_Sharers ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_sharers_contentno') THEN
        CREATE INDEX idx_sharers_contentno ON public."Board_Sharers" (ContentNo);
    END IF;
END;
$$;
