-- ─── INDEX: ix_hfsmsdata ON hfsmsdata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_hfsmsdata') THEN
        CREATE INDEX ix_hfsmsdata ON public."hfsmsdata" (intstate);
    END IF;
END;
$$;
