-- ─── FUNCTION: schedule_gettodogroupcounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodogroupcounts(integer);
CREATE OR REPLACE FUNCTION public.schedule_gettodogroupcounts(
    userno integer
) RETURNS TABLE(
    groupno text,
    iscomplete text,
    groupcount text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, IsComplete, COUNT(GroupNo) AS GroupCount
	FROM ScheduleToDos
	WHERE RegUserNo = schedule_gettodogroupcounts.userno
	GROUP BY GroupNo, IsComplete
	ORDER BY GroupNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
