-- ─── INDEX: idx_board_contents_c ON Board_Contents ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_board_contents_c') THEN
        CREATE INDEX idx_board_contents_c ON public."Board_Contents" (ContentNo);
    END IF;
END;
$$;
