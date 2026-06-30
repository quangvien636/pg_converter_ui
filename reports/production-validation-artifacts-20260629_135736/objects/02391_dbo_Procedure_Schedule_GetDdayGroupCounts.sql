-- ─── PROCEDURE→FUNCTION: schedule_getddaygroupcounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaygroupcounts(integer);
CREATE OR REPLACE FUNCTION public.schedule_getddaygroupcounts(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
