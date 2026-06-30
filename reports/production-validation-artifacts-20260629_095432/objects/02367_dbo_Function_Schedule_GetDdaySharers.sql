-- ─── FUNCTION: schedule_getddaysharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysharers();
CREATE OR REPLACE FUNCTION public.schedule_getddaysharers(
) RETURNS TABLE(
    ddayno text,
    userno text,
    userid text,
    username text,
    departno text,
    departname text,
    departnameen text,
    positionno text,
    positionname text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		S.DdayNo, S.UserNo, 
		COALESCE(U.UserID, '') AS UserID, COALESCE(U.Name, '') As UserName,
		S.DepartNo, COALESCE(D.Name, '') AS DepartName, COALESCE(D.Name_EN, '') AS DepartNameEN,
		S.PositionNo, COALESCE(P.Name, '') AS PositionName
	FROM ScheduleDdaySharers S
	LEFT JOIN Organization_Users U ON U.UserNo = S.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = S.DepartNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = S.PositionNo
	WHERE S.DdayNo = DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
