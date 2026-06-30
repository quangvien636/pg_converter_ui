-- ─── FUNCTION: workingtime_getcalculaterforday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getcalculaterforday(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getcalculaterforday(
    workingday integer,
    sort integer
) RETURNS TABLE(
    workingday text,
    timecheckin text,
    timecheckout text,
    timecheckout text,
    timework text,
    name text,
    userno text,
    photo text,
    possitionname text
)
AS $function$
BEGIN
	IF Sort=1
		BEGIN
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
		END
	ELSE IF Sort=2
		BEGIN
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
		END
	ELSE IF Sort=3
		BEGIN
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
