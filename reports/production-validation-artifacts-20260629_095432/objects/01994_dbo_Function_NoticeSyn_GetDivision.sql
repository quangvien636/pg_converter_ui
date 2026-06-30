-- ─── FUNCTION: noticesyn_getdivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getdivision(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getdivision(
    divisionno integer
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    sort text,
    viewmode text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name,Sort,viewmode
	FROM NoticeSyn_Divisions
	WHERE DivisionNo= noticesyn_getdivision.divisionno

END;

----------------------------------------//////////////////////////////////
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
