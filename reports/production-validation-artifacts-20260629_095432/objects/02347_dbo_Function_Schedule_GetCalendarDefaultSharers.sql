-- ─── FUNCTION: schedule_getcalendardefaultsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendardefaultsharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendardefaultsharers(
    calendarno integer
) RETURNS TABLE(
    calendarno text,
    userno text,
    userid text,
    username text,
    departno text,
    departname text,
    positionno text,
    positionname text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CalendarNo, S.UserNo, COALESCE(U.UserID, '') AS UserID,
		COALESCE(U.Name, '') AS UserName,
		S.DepartNo, COALESCE(D.Name, '') AS DepartName,
		S.PositionNo, COALESCE(P.Name,'') AS PositionName
	FROM ScheduleCalendarDefaultSharers S
	LEFT JOIN Organization_Users U ON U.UserNo = S.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = S.DepartNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = S.PositionNo
	WHERE CalendarNo = schedule_getcalendardefaultsharers.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
