-- ─── FUNCTION: contacts_getlocationonecontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getlocationonecontact(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getlocationonecontact(
    reguserno integer,
    contactuserid integer
) RETURNS TABLE(
    locationno text,
    reguserno text,
    name text,
    latitude text,
    longitude text,
    description text,
    contactuserid text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT LocationNo,RegUserNo,Name,Latitude,Longitude,Description,ContactUserId 
	FROM Contacts_Locations
	WHERE RegUserNo=contacts_getlocationonecontact.reguserno AND ContactUserId=contacts_getlocationonecontact.contactuserid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
