-- ─── INDEX: ix_hfconvdata_1 ON hfconvdata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_hfconvdata_1') THEN
        CREATE INDEX ix_hfconvdata_1 ON public."hfconvdata" (intstate);
    END IF;
END;
$$;
