-- ─── INDEX: idx_b ON Mail_Mails ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_b') THEN
        CREATE INDEX idx_b ON public."Mail_Mails" (BoxNo, IsDelete, ReadDate);
    END IF;
END;
$$;
