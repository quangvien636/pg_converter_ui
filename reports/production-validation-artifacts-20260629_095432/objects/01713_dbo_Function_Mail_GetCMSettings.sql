-- ─── FUNCTION: mail_getcmsettings ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getcmsettings(integer);
CREATE OR REPLACE FUNCTION public.mail_getcmsettings(
    userno integer
) RETURNS TABLE(
    popacc text,
    domain text,
    autoyn text,
    automessage text,
    autostartdate text,
    autoenddate text,
    maxdisk text,
    forward text,
    forwardremark text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT PopAcc, Domain, AutoYN, AutoMessage, AutoStartDate, AutoEndDate, MaxDisk, Forward, ForwardRemark
	FROM Mail_CMSettings
	WHERE UserNo = mail_getcmsettings.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
