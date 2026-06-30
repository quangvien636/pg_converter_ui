-- ─── FUNCTION: schedule_gettodosharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettodosharers();
CREATE OR REPLACE FUNCTION public.schedule_gettodosharers(
) RETURNS TABLE(
    todono text,
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
	SELECT
		S.ToDoNo, S.UserNo,
		COALESCE(U.UserID,'') As UserID, COALESCE(U.Name, '') As UserName,
		S.DepartNo, COALESCE(D.Name,'') As DepartName,
		S.PositionNo, COALESCE(P.Name,'') AS PositionName
	FROM ScheduleToDoSharers S
	LEFT JOIN Organization_Users U ON U.UserNo = S.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = S.DepartNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = S.PositionNo
	WHERE S.ToDoNo = ToDoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
