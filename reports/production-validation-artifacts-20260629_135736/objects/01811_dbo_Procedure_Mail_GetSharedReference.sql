-- ─── PROCEDURE→FUNCTION: mail_getsharedreference ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getsharedreference(bigint);
CREATE OR REPLACE FUNCTION public.mail_getsharedreference(
    IN mailno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select A.ReferenceNo,A.MailNo,A.UserNo,A.ReadDate,A.ModDate ,B.Name as UserName
	from Mail_SharedReference A
	join Organization_Users B
	on A.UserNo = B.UserNo
	where A.MailNo = mail_getsharedreference.mailno
	order by A.ReadDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
