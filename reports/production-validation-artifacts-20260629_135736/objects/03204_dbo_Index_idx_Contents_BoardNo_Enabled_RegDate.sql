-- ─── INDEX: idx_contents_boardno_enabled_regdate ON Board_Contents ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_contents_boardno_enabled_regdate') THEN
        CREATE INDEX idx_contents_boardno_enabled_regdate ON public."Board_Contents" (BoardNo, Enabled, RegDate);
    END IF;
END;
$$;
