-- ─── INDEX: idx_eappdocument_writerid_state_isclose ON EAPPDocument ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappdocument_writerid_state_isclose') THEN
        CREATE INDEX idx_eappdocument_writerid_state_isclose ON public."EAPPDocument" (WriterID, State, IsClose);
    END IF;
END;
$$;
