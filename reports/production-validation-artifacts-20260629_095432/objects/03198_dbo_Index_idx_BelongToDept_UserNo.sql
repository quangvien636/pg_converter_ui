-- ─── INDEX: idx_belongtodept_userno ON Organization_BelongToDepartment ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_belongtodept_userno') THEN
        CREATE INDEX idx_belongtodept_userno ON public."Organization_BelongToDepartment" (UserNo);
    END IF;
END;
$$;
