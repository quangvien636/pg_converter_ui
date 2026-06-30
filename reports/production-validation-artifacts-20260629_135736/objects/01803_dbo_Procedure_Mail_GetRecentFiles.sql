-- ─── PROCEDURE→FUNCTION: mail_getrecentfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getrecentfiles(integer);
CREATE OR REPLACE FUNCTION public.mail_getrecentfiles(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    recentno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Mail_RecentMailFiles WHERE UserNo = mail_getrecentfiles.userno) = 30 THEN
	

		SELECT MIN(RecentNo) INTO recentno FROM Mail_RecentMailFiles WHERE UserNo = mail_getrecentfiles.userno
		
		DELETE FROM Mail_RecentMailFiles WHERE RecentNo = RecentNo
	
	END IF;

	RETURN QUERY
	SELECT F.RecentNo, F.UserNo, F.MailNo, F.FileNo, F.Name, F.Size, F.ActionDate,
		M.Title AS MailTitle
	FROM Mail_RecentMailFiles F
	INNER JOIN Mail_Mails M ON M.MailNo = F.MailNo
	WHERE F.UserNo = mail_getrecentfiles.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
