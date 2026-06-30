-- ─── INDEX: ix_hfconvdata ON hfconvdata ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_hfconvdata') THEN
        CREATE INDEX ix_hfconvdata ON public."hfconvdata" (strsid);
    END IF;
END;
$$;
