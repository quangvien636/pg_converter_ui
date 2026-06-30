-- ─── INDEX: idx_eappreceive_progid ON EAPPReceive ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappreceive_progid') THEN
        CREATE INDEX idx_eappreceive_progid ON public."EAPPReceive" (ProgID);
    END IF;
END;
$$;
