-- ─── INDEX: idx_eapplinkquery_formid ON EAPPLinkQuery ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eapplinkquery_formid') THEN
        CREATE INDEX idx_eapplinkquery_formid ON public."EAPPLinkQuery" (formid);
    END IF;
END;
$$;
