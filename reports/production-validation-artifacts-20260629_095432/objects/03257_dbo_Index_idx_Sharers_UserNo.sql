-- ─── INDEX: idx_sharers_userno ON Board_Sharers ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_sharers_userno') THEN
        CREATE INDEX idx_sharers_userno ON public."Board_Sharers" (UserNo);
    END IF;
END;
$$;
