-- ─── FUNCTION: mail_getcmsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getcmsetting(integer, character varying);
CREATE OR REPLACE FUNCTION public.mail_getcmsetting(
    userno integer,
    popacc character varying
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
	WHERE UserNo = mail_getcmsetting.userno AND PopAcc = mail_getcmsetting.popacc AND Domain = Domain;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
