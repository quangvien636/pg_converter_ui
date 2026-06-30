-- ─── FUNCTION: work_getregularworkjournaldivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkjournaldivisions(integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkjournaldivisions(
    parentno integer
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    parentno text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, REGDATE, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled
	FROM RegularWorkJournalDivisions
	WHERE ParentNo = work_getregularworkjournaldivisions.parentno AND Enabled = TRUE
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
