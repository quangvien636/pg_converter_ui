-- ─── PROCEDURE→FUNCTION: notice_getpermissionforuser2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getpermissionforuser2(integer, integer);
CREATE OR REPLACE FUNCTION public.notice_getpermissionforuser2(
    IN p_uno integer,
    IN p_dno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
