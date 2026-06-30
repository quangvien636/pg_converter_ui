-- ─── INDEX: idx_userid ON EDMSAuthUser ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_userid') THEN
        CREATE INDEX idx_userid ON public."EDMSAuthUser" (UserID);
    END IF;
END;
$$;
