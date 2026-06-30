-- ─── FUNCTION: fn_getdepartmentname ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_getdepartmentname(integer);
CREATE OR REPLACE FUNCTION public.fn_getdepartmentname(
    departno integer
) RETURNS character varying
AS $function$
BEGIN


	select name =
	CASE 
		WHEN Lang ='VN' THEN a.Name_VN
		WHEN  Lang ='JP' THEN a.Name_JP
		WHEN  Lang ='CH' THEN a.Name_CH
		WHEN  Lang ='EN' THEN a.Name_EN
		ELSE a.Name 
	END
	from Organization_Departments a
	where DepartNo  = fn_getdepartmentname.departno
	return name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
