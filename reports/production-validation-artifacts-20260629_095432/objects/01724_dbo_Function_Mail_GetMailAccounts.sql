-- ─── FUNCTION: mail_getmailaccounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailaccounts(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailaccounts(
    userno integer
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


	IF (UserNo = -1) BEGIN
	
		RETURN QUERY
		SELECT AccountNo, UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd,
			IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled
		FROM Mail_Accounts
		WHERE UserNo != -1
		ORDER BY IsServerAccount DESC, UserNo ASC
		
	END

	ELSE BEGIN
	
		RETURN QUERY
		SELECT AccountNo, UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd,
			IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled
		FROM Mail_Accounts
		WHERE UserNo = mail_getmailaccounts.userno
		ORDER BY IsServerAccount DESC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
