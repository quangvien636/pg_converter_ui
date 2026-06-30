-- ─── INDEX: ix_hfreceivedata ON hfreceivedata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_hfreceivedata') THEN
        CREATE INDEX ix_hfreceivedata ON public."hfreceivedata" (intid, intstate);
    END IF;
END;
$$;
