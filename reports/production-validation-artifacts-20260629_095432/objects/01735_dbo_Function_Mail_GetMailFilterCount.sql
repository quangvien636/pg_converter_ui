-- ─── FUNCTION: mail_getmailfiltercount ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailfiltercount(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.mail_getmailfiltercount(
    userno integer,
    fieldfg character varying,
    conditionfg character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT COUNT(*)
	FROM Mail_MailFilters
	WHERE UserNo = mail_getmailfiltercount.userno AND FieldFg = mail_getmailfiltercount.fieldfg AND ConditionFg = mail_getmailfiltercount.conditionfg AND ExecValue = ExecValue;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
