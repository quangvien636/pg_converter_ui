-- ─── INDEX: idx_sharers_departno ON Board_Sharers ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_sharers_departno') THEN
        CREATE INDEX idx_sharers_departno ON public."Board_Sharers" (DepartNo);
    END IF;
END;
$$;
