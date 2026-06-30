-- ─── INDEX: idx_eappreceive_progid_receiverid_state ON EAPPReceive ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eappreceive_progid_receiverid_state') THEN
        CREATE INDEX idx_eappreceive_progid_receiverid_state ON public."EAPPReceive" (ReceiverID, ReceiveState);
    END IF;
END;
$$;
