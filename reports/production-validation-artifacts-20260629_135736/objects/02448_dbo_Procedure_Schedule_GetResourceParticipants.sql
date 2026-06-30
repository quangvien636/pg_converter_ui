-- ─── PROCEDURE→FUNCTION: schedule_getresourceparticipants ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourceparticipants(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourceparticipants(
    IN reservationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
