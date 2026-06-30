-- ─── INDEX: idx_orgcd ON EDMSAuthDepart ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_orgcd') THEN
        CREATE INDEX idx_orgcd ON public."EDMSAuthDepart" (ORGCD);
    END IF;
END;
$$;
