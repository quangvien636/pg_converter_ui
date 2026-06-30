-- ─── INDEX: idx_crewchat_messages_roomnomessageno ON CrewChat_Messages ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_crewchat_messages_roomnomessageno') THEN
        CREATE INDEX idx_crewchat_messages_roomnomessageno ON public."CrewChat_Messages" (RoomNo, MessageNo);
    END IF;
END;
$$;
