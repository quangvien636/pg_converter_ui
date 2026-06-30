-- ─── FUNCTION: work_getworkgrouppersons ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgrouppersons(integer, boolean);
CREATE OR REPLACE FUNCTION public.work_getworkgrouppersons(
    groupno integer,
    isdetail boolean
) RETURNS TABLE(
    groupno text,
    userno text
)
AS $function$
BEGIN


	IF IsDetail = TRUE BEGIN

		RETURN QUERY
		SELECT W.GroupNo, W.UserNo, U.UserID, U.Name AS UserName,
			P.Name AS PositionName, D.Name AS DepartName
		FROM WorkGroupPersons W
		LEFT JOIN Organization_Users U ON U.UserNo = W.UserNo
		LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = W.UserNo
		LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		WHERE W.GroupNo = work_getworkgrouppersons.groupno
		ORDER BY P.SortNo ASC
		
	END
	
	ELSE BEGIN
		
		RETURN QUERY
		SELECT W.GroupNo, W.UserNo
		FROM WorkGroupPersons W
		WHERE W.GroupNo = work_getworkgrouppersons.groupno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
