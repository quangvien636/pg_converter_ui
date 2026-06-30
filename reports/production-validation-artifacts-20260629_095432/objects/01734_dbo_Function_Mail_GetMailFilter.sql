-- ─── FUNCTION: mail_getmailfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailfilter(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailfilter(
    filterno bigint
) RETURNS TABLE(
    userno text,
    fieldfg text,
    conditionfg text,
    execfg text,
    execvalue text,
    mailboxno text,
    mailboxname text,
    sortno text,
    msortno text,
    parentno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT F.UserNo, F.FieldFg, F.ConditionFg, F.ExecFg, F.ExecValue,
		F.MailBoxNo, COALESCE(M.Name, '') AS MailBoxName, F.SortNo,M.SortNo as MSortNo , M.ParentNo
	FROM Mail_MailFilters F
	LEFT JOIN Mail_MailBoxs M ON M.BoxNo = F.MailBoxNo
	WHERE FilterNo = mail_getmailfilter.filterno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
