-- ─── FUNCTION: notice_getpermissionforuser2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getpermissionforuser2(integer, integer);
CREATE OR REPLACE FUNCTION public.notice_getpermissionforuser2(
    p_uno integer,
    p_dno integer
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN


	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = notice_getpermissionforuser2.p_uno or  DepartNo = notice_getpermissionforuser2.p_dno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) 

	RETURN QUERY
	select count(p.DeparNo) as Permission  from NoticePermissions p where p.DeparNo in
	(select name_tree.DepartNo from name_tree);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
