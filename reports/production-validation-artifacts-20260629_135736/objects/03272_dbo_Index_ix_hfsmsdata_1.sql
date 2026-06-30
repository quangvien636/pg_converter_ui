-- ─── INDEX: ix_hfsmsdata_1 ON hfsmsdata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_hfsmsdata_1') THEN
        CREATE INDEX ix_hfsmsdata_1 ON public."hfsmsdata" (strsid);
    END IF;
END;
$$;
