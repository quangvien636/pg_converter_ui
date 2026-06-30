-- ─── FUNCTION: organization_departments_getpath ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_departments_getpath(integer);
CREATE OR REPLACE FUNCTION public.organization_departments_getpath(
    p_fno integer
) RETURNS character varying
AS $function$
BEGIN

	-- Declare the return variable here


	with Organization_Departments_tree as 
	(
	   select DepartNo, ParentNo, Name
	   from Organization_Departments
	   where DepartNo = organization_departments_getpath.p_fno -- this is the starting point you want in your recursion
	   union all
	   select C.DepartNo, C.ParentNo, c.Name
	   from Organization_Departments c
	   join Organization_Departments_tree p on C.DepartNo = P.ParentNo  -- this is the recursion
	AND C.DepartNo <> C.ParentNo AND Enabled = TRUE
	) 

	  SELECT result = STUFF(
				 (SELECT || ' / ' || Name
				  FROM Organization_Departments_tree order by DepartNo 
				  FOR XML PATH (''))
				 , 1, 2, '')
		-- Return the result of the function
		RETURN result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
