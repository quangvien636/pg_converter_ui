-- ─── FUNCTION: notice_getdivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getdivision(integer);
CREATE OR REPLACE FUNCTION public.notice_getdivision(
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
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name,Sort, ViewMode
	FROM NoticeDivisions
	WHERE DivisionNo= notice_getdivision.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
