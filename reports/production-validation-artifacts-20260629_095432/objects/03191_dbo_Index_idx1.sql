-- ─── INDEX: idx1 ON EAPPForm ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx1') THEN
        CREATE INDEX idx1 ON public."EAPPForm" (IsDelete, IsUsing, ErpType);
    END IF;
END;
$$;
