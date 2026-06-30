-- ─── FUNCTION: work_getregularworkgroupdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroupdivisions();
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupdivisions(
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, REGDATE, ModUserNo, ModDate, Name, SortNo, Enabled
	FROM RegularWorkGroupDivisions
	WHERE Enabled = TRUE
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
