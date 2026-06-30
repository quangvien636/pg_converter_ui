-- ─── FUNCTION: workingtime_getalldepartbyuid ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getalldepartbyuid(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getalldepartbyuid(
    p_uno integer
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN


	with name_tree as 
	(
 		SELECT d.DepartNo, d.ParentNo
		FROM Organization_Departments d
		WHERE d.DepartNo IN (
			SELECT b.DepartNo FROM Organization_BelongToDepartment  b
			WHERE b.UserNo = workingtime_getalldepartbyuid.p_uno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) 
	RETURN QUERY
	select tr.DepartNo
	from name_tree tr;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
