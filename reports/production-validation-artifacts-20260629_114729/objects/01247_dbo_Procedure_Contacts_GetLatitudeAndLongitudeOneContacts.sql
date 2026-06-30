-- ─── PROCEDURE→FUNCTION: contacts_getlatitudeandlongitudeonecontacts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getlatitudeandlongitudeonecontacts(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlatitudeandlongitudeonecontacts(
    IN contactid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT CA.UserSeq,CA.Longitude,CA.Latitude,CU.FirstName,CU.LastName,CA.Address 
	FROM ContactsAddress CA
	LEFT JOIN ContactsUser CU
	ON CA.UserSeq=CU.Seq
	WHERE CA.UserSeq=contacts_getlatitudeandlongitudeonecontacts.contactid AND CA.Latitude!=0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
