-- ─── FUNCTION: workingtime_getcalculaterstatusforday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getcalculaterstatusforday(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getcalculaterstatusforday(
    workingday integer,
    type integer
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
    IF Type=1
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
				WHERE WorkingDay=workingtime_getcalculaterstatusforday.workingday AND (Type=1 Or Type=4)
				ORDER BY Calculaterno ASC
		END
	ELSE IF Type=6
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
						WHERE WorkingDay=workingtime_getcalculaterstatusforday.workingday 
						ORDER BY Calculaterno DESC
			END
		ELSE
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
						WHERE WorkingDay=workingtime_getcalculaterstatusforday.workingday AND Type=workingtime_getcalculaterstatusforday.type
						ORDER BY Calculaterno ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
