-- ─── PROCEDURE→FUNCTION: schedule_getddaygroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaygroups(integer);
CREATE OR REPLACE FUNCTION public.schedule_getddaygroups(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		RETURN QUERY
		SELECT S.GroupNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, COALESCE(T.TagImageNo,0) AS TagImageNo
	FROM ScheduleDdayGroups S
	LEFT JOIN ScheduleDdaysTag T ON T.UserNo = schedule_getddaygroups.userno AND S.GroupNo = T.GroupNo
	WHERE S.GroupNo  IN (SELECT GroupNo 
						FROM ScheduleDdays 
						WHERE RegUserNo = schedule_getddaygroups.userno 
							OR DdayNo in (select DdayNo from ScheduleDdaySharers where UserNo = schedule_getddaygroups.userno  GROUP BY DdayNo )
						GROUP BY GroupNo) 
			OR RegUserNo = schedule_getddaygroups.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
