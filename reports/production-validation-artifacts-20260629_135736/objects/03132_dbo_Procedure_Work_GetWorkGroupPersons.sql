-- ─── PROCEDURE→FUNCTION: work_getworkgrouppersons ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getworkgrouppersons(integer, boolean);
CREATE OR REPLACE FUNCTION public.work_getworkgrouppersons(
    IN groupno integer,
    IN isdetail boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDetail = TRUE THEN

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
		
	END IF;
	
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
