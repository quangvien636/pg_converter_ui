-- ─── INDEX: idx_crewchat_checkmessage_r_u_i_m ON CrewChat_CheckMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_crewchat_checkmessage_r_u_i_m') THEN
        CREATE INDEX idx_crewchat_checkmessage_r_u_i_m ON public."CrewChat_CheckMessage" (RoomNo, UserNo, IsRead, MessageNo);
    END IF;
END;
$$;
