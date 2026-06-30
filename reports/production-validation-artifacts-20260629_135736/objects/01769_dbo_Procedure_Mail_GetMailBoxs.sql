-- ─── PROCEDURE→FUNCTION: mail_getmailboxs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.mail_getmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailboxs(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BoxNo, UserNo, Name, ParentNo, SortNo, ModDate, TotalCount, 
	CASE SortNo  
	WHEN 7 THEN (SELECT /* TOP 1 */ UnReadCount FROM Mail_MailBoxs B where B.UserNo = mail_getmailboxs.userno and SortNo = 1) 
	ELSE UnReadCount 
	END UnReadCount,
	IsShare
	FROM Mail_MailBoxs
	WHERE UserNo = mail_getmailboxs.userno
	ORDER BY SortNo DESC, Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
