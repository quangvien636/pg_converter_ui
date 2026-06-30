-- ─── INDEX: idx_tcmbusinessinfo_reguserid ON TCMBusinessInfo ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_tcmbusinessinfo_reguserid') THEN
        CREATE INDEX idx_tcmbusinessinfo_reguserid ON public."TCMBusinessInfo" (RegUserID);
    END IF;
END;
$$;
