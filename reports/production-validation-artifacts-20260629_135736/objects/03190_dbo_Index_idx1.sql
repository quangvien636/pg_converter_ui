-- ─── INDEX: idx1 ON EAPPData ─────────────────────
-- TODO: SQL Server CLUSTERED index detected. PostgreSQL does not maintain clustered indexes the same way. Manual review required.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx1') THEN
        CREATE INDEX idx1 ON public."EAPPData" (DocID);
    END IF;
END;
$$;
