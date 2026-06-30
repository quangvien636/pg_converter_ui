-- ─── PROCEDURE→FUNCTION: workingtime_getcalculaterforday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getcalculaterforday(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getcalculaterforday(
    IN workingday integer,
    IN sort integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	IF Sort=1 THEN
			RETURN QUERY
			SELECT WC.WorkingDay,WC.TimeCheckIn,WC.TimeCheckOut,WC.TimeCheckOut,WC.TimeWork,O.Name,O.UserNo,O.Photo,P.Name_EN AS PossitionName
			FROM WorkingTime_Calculater WC
			INNER JOIN Organization_Users O
			ON WC.UserNo=O.UserNo
			INNER JOIN Organization_BelongToDepartment BL
			ON BL.UserNo=O.UserNo
			INNER JOIN Organization_Positions P
			ON P.PositionNo=BL.PositionNo
			WHERE WorkingDay=workingtime_getcalculaterforday.workingday
			ORDER BY Calculaterno ASC
		END IF;
	ELSIF Sort=2 THEN
		    RETURN QUERY
		    SELECT WC.WorkingDay,WC.TimeCheckIn,WC.TimeCheckOut,WC.TimeCheckOut,WC.TimeWork,O.Name,O.UserNo,O.Photo,P.Name_EN AS PossitionName
			FROM WorkingTime_Calculater WC
			INNER JOIN Organization_Users O
			ON WC.UserNo=O.UserNo
			INNER JOIN Organization_BelongToDepartment BL
			ON BL.UserNo=O.UserNo
			INNER JOIN Organization_Positions P
			ON P.PositionNo=BL.PositionNo
			WHERE WorkingDay=workingtime_getcalculaterforday.workingday
			ORDER BY Calculaterno DESC
		END IF;
	ELSIF Sort=3 THEN
			RETURN QUERY
			SELECT WC.WorkingDay,WC.TimeCheckIn,WC.TimeCheckOut,WC.TimeCheckOut,WC.TimeWork,O.Name,O.UserNo,O.Photo,P.Name_EN AS PossitionName
			FROM WorkingTime_Calculater WC
			INNER JOIN Organization_Users O
			ON WC.UserNo=O.UserNo
			INNER JOIN Organization_BelongToDepartment BL
			ON BL.UserNo=O.UserNo
			INNER JOIN Organization_Positions P
			ON P.PositionNo=BL.PositionNo
			WHERE WorkingDay=workingtime_getcalculaterforday.workingday
			ORDER BY TimeWork DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
