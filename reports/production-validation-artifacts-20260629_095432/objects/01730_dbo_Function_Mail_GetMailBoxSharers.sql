-- ─── FUNCTION: mail_getmailboxsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailboxsharers(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailboxsharers(
    boxno bigint
) RETURNS TABLE(
    boxno bigint,
    reguserno integer,
    userno integer,
    positionno integer,
    departno integer,
    permission integer
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT * FROM Mail_MailBoxSharers
	WHERE BoxNo = mail_getmailboxsharers.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
