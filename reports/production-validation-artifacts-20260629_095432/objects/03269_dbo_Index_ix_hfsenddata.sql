-- ─── INDEX: ix_hfsenddata ON hfsenddata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_hfsenddata') THEN
        CREATE INDEX ix_hfsenddata ON public."hfsenddata" (strsid);
    END IF;
END;
$$;
