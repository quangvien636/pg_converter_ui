-- ─── INDEX: idx_crewchat_checkmessage_roomno_userno_isread ON CrewChat_CheckMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_crewchat_checkmessage_roomno_userno_isread') THEN
        CREATE INDEX idx_crewchat_checkmessage_roomno_userno_isread ON public."CrewChat_CheckMessage" (RoomNo, UserNo, IsRead);
    END IF;
END;
$$;
