-- ─── FUNCTION: workingtime_getcompanyname ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getcompanyname(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getcompanyname(
    p_uno integer
) RETURNS character varying
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	  with name_tree as 
	  (
	   select DepartNo, ParentNo, Name, Name_EN
	   from Organization_Departments
	   where DepartNo in(
		 select DepartNo from	Organization_BelongToDepartment where UserNo = workingtime_getcompanyname.p_uno
	   ) 
	   union all
	   select C.DepartNo, C.ParentNo, c.Name,  c.Name_EN
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  -- this is the recursion
		AND C.DepartNo<>C.ParentNo
	) 
	SELECT result =  (SELECT /* TOP 1 */ Name  from name_tree where ParentNo = 0)
	RETURN result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
