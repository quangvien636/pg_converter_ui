-- ─── FUNCTION: mail_deletemailfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailfilter(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailfilter(
    filterno bigint
) RETURNS void
AS $function$
BEGIN



	SELECT UserNo = UserNo, SortOrd = SortNo
	FROM Mail_MailFilters WHERE FilterNo = mail_deletemailfilter.filterno
	
	UPDATE Mail_MailFilters SET SortNo = SortNo - 1 WHERE UserNo = UserNo AND SortNo > SortOrd

    DELETE FROM Mail_MailFilters WHERE FilterNo = mail_deletemailfilter.filterno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
