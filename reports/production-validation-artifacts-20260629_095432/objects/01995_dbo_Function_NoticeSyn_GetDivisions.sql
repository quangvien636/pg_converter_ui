-- ─── FUNCTION: noticesyn_getdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getdivisions();
CREATE OR REPLACE FUNCTION public.noticesyn_getdivisions(
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
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Sort,viewmode
	FROM NoticeSyn_Divisions
	ORDER BY Sort ASC, DivisionNo ASC

END;
-----------------------.///////////////////////////////----------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
