-- ─── INDEX: idx_center_sessions_userno_userid_sessionid ON Center_Sessions ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_center_sessions_userno_userid_sessionid') THEN
        CREATE INDEX idx_center_sessions_userno_userid_sessionid ON public."Center_Sessions" (UserNo, UserID, SessionID);
    END IF;
END;
$$;
