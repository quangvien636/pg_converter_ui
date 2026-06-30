-- ─── FUNCTION: mail_insertmailaccount ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailaccount(integer, integer, timestamp without time zone, character varying, integer, character varying, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_insertmailaccount(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    server character varying,
    port integer,
    popuser character varying,
    poppwd character varying,
    isserveraccount boolean,
    issharedaccount boolean,
    isdeleteemlfile boolean,
    iswebmail boolean,
    name character varying,
    mailaddress character varying,
    enabled boolean
) RETURNS TABLE(
    accountno text
)
AS $function$
DECLARE
    accountno bigint;
BEGIN


	INSERT INTO Mail_Accounts (UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd, IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled)
	VALUES(UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd, IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled)
	

	SET AccountNo = lastval()
	
	RETURN QUERY
	SELECT AccountNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
