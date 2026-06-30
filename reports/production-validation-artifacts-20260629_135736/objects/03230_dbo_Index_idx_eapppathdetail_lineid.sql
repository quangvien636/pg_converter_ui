-- ─── INDEX: idx_eapppathdetail_lineid ON EAPPPathDetail ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eapppathdetail_lineid') THEN
        CREATE INDEX idx_eapppathdetail_lineid ON public."EAPPPathDetail" (LineID);
    END IF;
END;
$$;
