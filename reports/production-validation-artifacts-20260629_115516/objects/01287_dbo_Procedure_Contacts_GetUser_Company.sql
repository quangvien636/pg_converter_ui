-- ─── PROCEDURE→FUNCTION: contacts_getuser_company ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser_company(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_company(
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
	Company,
	Depart,
	Position,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsCompany WHERE UserSeq = contacts_getuser_company.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
