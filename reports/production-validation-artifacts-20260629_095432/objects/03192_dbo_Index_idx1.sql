-- ─── INDEX: idx1 ON EAPPPostMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx1') THEN
        CREATE INDEX idx1 ON public."EAPPPostMessage" (Category, Code);
    END IF;
END;
$$;
