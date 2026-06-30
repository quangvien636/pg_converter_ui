-- ─── FUNCTION: schedule_getresourceparticipants ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceparticipants(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourceparticipants(
    reservationno integer
) RETURNS TABLE(
    reservationno text,
    userno text,
    userid text,
    username text,
    departno text,
    departname text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ReservationNo, S.UserNo, COALESCE(U.UserID, '') AS UserID,
		COALESCE(U.Name, '') AS UserName,
		S.DepartNo, COALESCE(D.Name, '') AS DepartName
	FROM ScheduleResourceParticipants S
	LEFT JOIN Organization_Users U ON U.UserNo = S.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = S.DepartNo
	WHERE ReservationNo = schedule_getresourceparticipants.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
