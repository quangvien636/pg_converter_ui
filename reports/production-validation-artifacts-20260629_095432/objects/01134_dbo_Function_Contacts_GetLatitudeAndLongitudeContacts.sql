-- ─── FUNCTION: contacts_getlatitudeandlongitudecontacts ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getlatitudeandlongitudecontacts(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlatitudeandlongitudecontacts(
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
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
