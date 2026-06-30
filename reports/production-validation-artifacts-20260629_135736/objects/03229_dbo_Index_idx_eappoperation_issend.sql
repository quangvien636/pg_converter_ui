-- ─── INDEX: idx_eappoperation_issend ON EAPPOperation ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappoperation_issend') THEN
        CREATE INDEX idx_eappoperation_issend ON public."EAPPOperation" (IsSend);
    END IF;
END;
$$;
