-- ─── INDEX: idx_mail_mails_userno_boxno_isdelete ON Mail_Mails ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_mail_mails_userno_boxno_isdelete') THEN
        CREATE INDEX idx_mail_mails_userno_boxno_isdelete ON public."Mail_Mails" (UserNo, BoxNo, IsDelete);
    END IF;
END;
$$;
