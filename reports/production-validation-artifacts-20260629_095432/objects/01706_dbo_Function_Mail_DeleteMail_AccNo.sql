-- ─── FUNCTION: mail_deletemail_accno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemail_accno(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemail_accno(
    accountno bigint
) RETURNS void
AS $function$
BEGIN

	UPDATE Mail_Mails
	SET IsDelete = TRUE, TagNo = 0 ,DeleteDate = NOW()
	WHERE AccNo = mail_deletemail_accno.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
