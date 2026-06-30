-- ─── FUNCTION: workingtime_getworkingtimelocations2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimelocations2();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimelocations2(
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
    description text,
    col11 text,
    enabled text,
    col13 text,
    col14 text,
    col15 text,
    col16 text,
    col17 text,
    col18 text,
    col19 text
)
AS $function$
BEGIN


RETURN QUERY
SELECT l.LocationNo, L.RegUserNo, L.RegDate, l.ModUserNo, l.ModDate, l.Name, Latitude, Longitude, ErrorRange, Description, COALESCE(Description2,'') Description2, l.Enabled
		   , COALESCE(Representation,'') Representation
		   , COALESCE(PhoneNumber,'') PhoneNumber
		   , 0 TType
		   , COALESCE(G.GType,0) GType
		   , COALESCE(G.GName,'')  GName
		   , COALESCE(u.Name,'') UserName
		   , COALESCE(u.Name_EN,'') UserNameEn
	FROM WorkingTime_Locations L
	LEFT JOIN WorkingTime_GroupPlace G ON L.GType = G.GNo
	LEFT JOIN Organization_Users U ON L.RegUserNo = U .UserNo
	UNION ALL
	
	RETURN QUERY
	SELECT  l.LocationNo, L.RegUserNo, L.RegDate, l.ModUserNo, l.ModDate, l.Name, Latitude, Longitude, ErrorRange, Description, COALESCE(Description2,'') Description2, l.Enabled
		   , COALESCE(Representation,'') Representation
		   , COALESCE(PhoneNumber,'') PhoneNumber
		   , 1 TType
		   , COALESCE(G.GType,0) GType
		   , COALESCE(G.GName,'')  GName
		   , COALESCE(u.Name,'') UserName
		   , COALESCE(u.Name_EN,'') UserNameEn
	FROM WorkingTime_LocationsOutside L
	LEFT JOIN WorkingTime_GroupPlace G ON L.GType = G.GNo
	LEFT JOIN Organization_Users U ON L.RegUserNo = U .UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
