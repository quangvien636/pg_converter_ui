-- ─── INDEX: idx_crewchat_pcdevices_serialnumber ON CrewChat_PCDevices ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_crewchat_pcdevices_serialnumber') THEN
        CREATE INDEX idx_crewchat_pcdevices_serialnumber ON public."CrewChat_PCDevices" (SerialNumber);
    END IF;
END;
$$;
