-- ─── PROCEDURE→FUNCTION: workingtime_getlocationformys ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocationformys(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationformys(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = workingtime_getlocationformys.p_uno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) ;
	insert into DepartNos
	RETURN QUERY
	select DepartNo from name_tree;

	RETURN QUERY
	SELECT LocationNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Latitude, Longitude, ErrorRange, Description, Enabled
	FROM WorkingTime_Locations l
	where   ',' || L.uids || ',' ILIKE '%,' || CONVERT(VARCHAR(50),p_uno)+',%'
	or EXISTS (
		SELECT D.DepartNo FROM DepartNos D  WHERE ',' || L.dids || ',' ILIKE '%,' || CONVERT(VARCHAR(50),D.DepartNo)+',%'
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
