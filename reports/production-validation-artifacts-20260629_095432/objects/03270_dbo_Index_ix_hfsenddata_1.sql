-- ─── INDEX: ix_hfsenddata_1 ON hfsenddata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_hfsenddata_1') THEN
        CREATE INDEX ix_hfsenddata_1 ON public."hfsenddata" (intstate);
    END IF;
END;
$$;
