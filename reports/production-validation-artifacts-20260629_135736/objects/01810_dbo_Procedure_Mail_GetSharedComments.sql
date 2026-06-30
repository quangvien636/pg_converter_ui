-- ─── PROCEDURE→FUNCTION: mail_getsharedcomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getsharedcomments(bigint);
CREATE OR REPLACE FUNCTION public.mail_getsharedcomments(
    IN mailno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select A.CommentNo, A.MailNo, A.RegUserNo, A.RegDate, A.ModDate, A.Content ,A.CommentsType ,B.Name as UserName
	from Mail_SharedComments A
	join Organization_Users B
	on A.RegUserNo = B.UserNo
	where A.MailNo = mail_getsharedcomments.mailno
	order by A.ModDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
