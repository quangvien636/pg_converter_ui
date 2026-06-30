-- ─── PROCEDURE→FUNCTION: contacts_getlatitudeandlongitudecontacts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getlatitudeandlongitudecontacts(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlatitudeandlongitudecontacts(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT CA.UserSeq,CA.Longitude,CA.Latitude,CU.FirstName,CU.LastName,CA.Address 
	FROM ContactsAddress CA
	LEFT JOIN ContactsUser CU
	ON CA.UserSeq=CU.Seq
	WHERE CA.RegUserNo=contacts_getlatitudeandlongitudecontacts.userno AND CU.UseYn='Y' AND CA.Latitude!=0	AND CA.Seq IN (SELECT MAX(Seq) FROM ContactsAddress GROUP BY Latitude);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
