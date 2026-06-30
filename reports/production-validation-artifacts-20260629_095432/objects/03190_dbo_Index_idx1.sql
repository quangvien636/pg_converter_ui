-- ─── INDEX: idx1 ON EAPPData ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx1') THEN
        CREATE INDEX idx1 ON public."EAPPData" (DocID);
    END IF;
END;
$$;
