-- ─── FUNCTION: mail_getmailfilters ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailfilters(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailfilters(
    userno integer
) RETURNS TABLE(
    filterno text,
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
	SELECT F.FilterNo, F.FieldFg, F.ConditionFg, F.ExecFg, F.ExecValue, F.MailBoxNo,
		COALESCE(M.Name, '') AS MailBoxName, F.SortNo,M.SortNo as MSortNo , M.ParentNo
	FROM Mail_MailFilters F 
	LEFT JOIN Mail_MailBoxs M ON M.BoxNo = F.MailBoxNo
	WHERE F.UserNo = mail_getmailfilters.userno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
