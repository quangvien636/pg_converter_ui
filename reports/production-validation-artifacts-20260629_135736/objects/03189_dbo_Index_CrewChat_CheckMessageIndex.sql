-- ─── INDEX: crewchat_checkmessageindex ON CrewChat_CheckMessage ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'crewchat_checkmessageindex') THEN
        CREATE INDEX crewchat_checkmessageindex ON public."CrewChat_CheckMessage" (UserNo, IsRead);
    END IF;
END;
$$;
