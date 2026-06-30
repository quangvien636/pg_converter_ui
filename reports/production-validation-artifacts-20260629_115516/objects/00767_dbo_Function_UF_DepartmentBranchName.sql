-- ─── FUNCTION: uf_departmentbranchname ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_departmentbranchname(integer);
CREATE OR REPLACE FUNCTION public.uf_departmentbranchname(
    userno integer
) RETURNS character varying
AS $function$
BEGIN


    with name_tree as 
	(
 		SELECT DepartNo, ParentNo, Name, Name_EN 
		      ,1 AS CatLevel
		FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = uf_departmentbranchname.userno
		)
	   union all
	   select C.DepartNo, C.ParentNo, c.Name, c.Name_EN
			  , 1 || CatLevel
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) 
	select  Name = tr.Name 
	from name_tree tr where tr.CatLevel = 2;
	RETURN Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
