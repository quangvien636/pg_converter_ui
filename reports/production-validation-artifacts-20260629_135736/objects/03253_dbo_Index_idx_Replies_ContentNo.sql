-- ─── INDEX: idx_replies_contentno ON Board_Replies ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_replies_contentno') THEN
        CREATE INDEX idx_replies_contentno ON public."Board_Replies" (ContentNo);
    END IF;
END;
$$;
