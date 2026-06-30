-- ─── PROCEDURE→FUNCTION: contacts_getuser_email ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser_email(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_email(
    IN userseq integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
	Seq, 
	RegUserNo,
	UserSeq,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsEmail WHERE UserSeq = contacts_getuser_email.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
