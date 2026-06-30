-- ─── FUNCTION: contacts_getlatitudeandlongitudeonecontacts ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getlatitudeandlongitudeonecontacts(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlatitudeandlongitudeonecontacts(
    contactid integer
) RETURNS TABLE(
    userseq text,
    longitude text,
    latitude text,
    firstname text,
    lastname text,
    address text
)
AS $function$
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
