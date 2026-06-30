-- ─── INDEX: idx__i_r ON Mail_Mails ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx__i_r') THEN
        CREATE INDEX idx__i_r ON public."Mail_Mails" (IsDelete, ReadDate);
    END IF;
END;
$$;
