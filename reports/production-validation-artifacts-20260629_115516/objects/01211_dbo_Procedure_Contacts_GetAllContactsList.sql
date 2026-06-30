-- ─── PROCEDURE→FUNCTION: contacts_getallcontactslist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getallcontactslist(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallcontactslist(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT U.Seq,
		COALESCE(U.FirstName, '') AS FirstName,
		COALESCE(U.LastName, '') AS LastName,
		COALESCE(E.Value, '') AS Value,
		COALESCE(C.Position, '') AS Position,
		COALESCE(C.Company, '') AS Company
	FROM ContactsUser U
	INNER JOIN ContactsEmail E ON E.UserSeq = U.Seq
	LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq
	WHERE (U.RegUserNo = contacts_getallcontactslist.userno or SUBSTRING(U.Share,1,3) = 300)  AND U.UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
