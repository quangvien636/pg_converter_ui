-- ─── INDEX: idx_mail_mails_userno_isdelete_readdate ON Mail_Mails ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_mail_mails_userno_isdelete_readdate') THEN
        CREATE INDEX idx_mail_mails_userno_isdelete_readdate ON public."Mail_Mails" (UserNo, IsDelete, ReadDate);
    END IF;
END;
$$;
