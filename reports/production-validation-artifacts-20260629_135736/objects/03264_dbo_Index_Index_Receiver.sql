-- ─── INDEX: index_receiver ON EAPPDocRotation ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'index_receiver') THEN
        CREATE INDEX index_receiver ON public."EAPPDocRotation" (Receiver, Rdel);
    END IF;
END;
$$;
