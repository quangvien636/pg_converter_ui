-- ─── FUNCTION: notice_getdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getdivisions();
CREATE OR REPLACE FUNCTION public.notice_getdivisions(
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
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Sort , ViewMode
	FROM NoticeDivisions
	ORDER BY Sort ASC, DivisionNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
