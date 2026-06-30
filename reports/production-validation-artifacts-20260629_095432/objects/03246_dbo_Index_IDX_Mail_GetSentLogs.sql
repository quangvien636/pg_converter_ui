-- ─── INDEX: idx_mail_getsentlogs ON Mail_Mails ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_mail_getsentlogs') THEN
        CREATE INDEX idx_mail_getsentlogs ON public."Mail_Mails" (CMSendNum, UserNo, IsSent);
    END IF;
END;
$$;
