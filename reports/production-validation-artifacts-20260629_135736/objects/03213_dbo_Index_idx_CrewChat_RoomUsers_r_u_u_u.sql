-- ─── INDEX: idx_crewchat_roomusers_r_u_u_u ON CrewChat_RoomUsers ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_crewchat_roomusers_r_u_u_u') THEN
        CREATE INDEX idx_crewchat_roomusers_r_u_u_u ON public."CrewChat_RoomUsers" (RoomNo, UserNo);
    END IF;
END;
$$;
