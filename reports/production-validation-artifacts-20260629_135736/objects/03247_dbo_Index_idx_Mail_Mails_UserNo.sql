-- ─── INDEX: idx_mail_mails_userno ON Mail_Mails ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_mail_mails_userno') THEN
        CREATE INDEX idx_mail_mails_userno ON public."Mail_Mails" (UserNo);
    END IF;
END;
$$;
