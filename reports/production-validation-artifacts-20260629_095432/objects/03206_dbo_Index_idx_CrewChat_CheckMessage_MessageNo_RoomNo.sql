-- ─── INDEX: idx_crewchat_checkmessage_messageno_roomno ON CrewChat_CheckMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_crewchat_checkmessage_messageno_roomno') THEN
        CREATE INDEX idx_crewchat_checkmessage_messageno_roomno ON public."CrewChat_CheckMessage" (MessageNo, RoomNo);
    END IF;
END;
$$;
