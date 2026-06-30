-- ─── INDEX: index_sender ON EAPPDocRotation ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'index_sender') THEN
        CREATE INDEX index_sender ON public."EAPPDocRotation" (Sender, Sdel);
    END IF;
END;
$$;
