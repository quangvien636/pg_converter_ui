-- ─── INDEX: idx_eapplinkscript_formid ON EAPPLinkScript ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eapplinkscript_formid') THEN
        CREATE INDEX idx_eapplinkscript_formid ON public."EAPPLinkScript" (formid);
    END IF;
END;
$$;
