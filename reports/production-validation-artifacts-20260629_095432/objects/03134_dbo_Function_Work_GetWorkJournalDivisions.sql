-- ─── FUNCTION: work_getworkjournaldivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkjournaldivisions(integer);
CREATE OR REPLACE FUNCTION public.work_getworkjournaldivisions(
    parentno integer
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    parentno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, REGDATE, ModUserNo, ModDate, Name, ParentNo
	FROM WorkJournalDivisions
	WHERE ParentNo = work_getworkjournaldivisions.parentno AND Enabled = TRUE
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
