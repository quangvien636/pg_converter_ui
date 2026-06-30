-- ─── FUNCTION: mail_getmailaccount ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailaccount(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailaccount(
    accountno bigint
) RETURNS TABLE(
    accountno text,
    userno text,
    moduserno text,
    moddate text,
    server text,
    port text,
    popuser text,
    poppwd text,
    isserveraccount text,
    issharedaccount text,
    isdeleteemlfile text,
    iswebmail text,
    name text,
    mailaddress text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT AccountNo, UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd,
		IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled
	FROM Mail_Accounts
	WHERE AccountNo = mail_getmailaccount.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
