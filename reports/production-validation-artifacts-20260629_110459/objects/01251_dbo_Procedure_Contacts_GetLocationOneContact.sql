-- ─── PROCEDURE→FUNCTION: contacts_getlocationonecontact ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getlocationonecontact(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getlocationonecontact(
    IN reguserno integer,
    IN contactuserid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT LocationNo,RegUserNo,Name,Latitude,Longitude,Description,ContactUserId 
	FROM Contacts_Locations
	WHERE RegUserNo=contacts_getlocationonecontact.reguserno AND ContactUserId=contacts_getlocationonecontact.contactuserid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
