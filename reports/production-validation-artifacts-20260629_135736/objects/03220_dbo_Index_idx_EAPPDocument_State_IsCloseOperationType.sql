-- ─── INDEX: idx_eappdocument_state_iscloseoperationtype ON EAPPDocument ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappdocument_state_iscloseoperationtype') THEN
        CREATE INDEX idx_eappdocument_state_iscloseoperationtype ON public."EAPPDocument" (State, IsClose, OperationType);
    END IF;
END;
$$;
