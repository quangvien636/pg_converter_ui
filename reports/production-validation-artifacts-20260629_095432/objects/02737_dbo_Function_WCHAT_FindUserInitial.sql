-- ─── FUNCTION: wchat_finduserinitial ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_finduserinitial();
CREATE OR REPLACE FUNCTION public.wchat_finduserinitial(
) RETURNS TABLE(
    name text
)
AS $function$
BEGIN


	
	RETURN QUERY
	SELECT U.Name
	FROM WCHATMembers M
	INNER JOIN Organization_Users U ON U.UserNo = M.UserNo
	WHERE PATINDEX(public."UF_RegularExText"(FindText) + '%' , U.Name) > 0
	--WHERE PATINDEX('%' || public."UF_RegularExText"(FindText) + '%' , U.UserNm1) > 0
	GROUP BY U.Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
