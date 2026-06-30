-- ─── FUNCTION: contacts_getlocations ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getlocations(integer);
CREATE OR REPLACE FUNCTION public.contacts_getlocations(
    contactuserid integer
) RETURNS TABLE(
    locationno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    latitude text,
    longitude text,
    errorrange text,
    description text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LocationNo, RegUserNo, RegDate, ModUserNo, ModDate,
		Name, Latitude, Longitude, ErrorRange, Description
	FROM Contacts_Locations
	WHERE ContactUserId=contacts_getlocations.contactuserid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
