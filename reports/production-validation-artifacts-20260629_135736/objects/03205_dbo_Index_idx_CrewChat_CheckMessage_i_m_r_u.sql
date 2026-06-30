-- ─── INDEX: idx_crewchat_checkmessage_i_m_r_u ON CrewChat_CheckMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_crewchat_checkmessage_i_m_r_u') THEN
        CREATE INDEX idx_crewchat_checkmessage_i_m_r_u ON public."CrewChat_CheckMessage" (IsRead);
    END IF;
END;
$$;
