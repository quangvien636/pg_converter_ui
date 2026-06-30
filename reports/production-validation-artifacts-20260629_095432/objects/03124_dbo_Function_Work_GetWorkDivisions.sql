-- ─── FUNCTION: work_getworkdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkdivisions();
CREATE OR REPLACE FUNCTION public.work_getworkdivisions(
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, REGDATE, ModUserNo, ModDate, Name
	FROM WorkDivisions
	WHERE Enabled = TRUE
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
