-- ─── FUNCTION: schedule_getddaygroupcounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaygroupcounts(integer);
CREATE OR REPLACE FUNCTION public.schedule_getddaygroupcounts(
    userno integer
) RETURNS TABLE(
    ddayno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, Count(*) AS Count
	FROM ScheduleDdays
	WHERE GroupNo  IN (SELECT GroupNo 
						FROM ScheduleDdays 
						WHERE RegUserNo = schedule_getddaygroupcounts.userno 
							OR DdayNo in (select DdayNo from ScheduleDdaySharers where UserNo = schedule_getddaygroupcounts.userno  GROUP BY DdayNo )
						GROUP BY GroupNo)

	GROUP BY GroupNo
	ORDER BY GroupNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
