-- ─── PROCEDURE→FUNCTION: drive_getpemissioncommonfoldersbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getpemissioncommonfoldersbyuser(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_getpemissioncommonfoldersbyuser(
    IN p_uno bigint,
    IN p_dno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	with name_tree as 
	(
 		SELECT DepartNo, ParentNo FROM Organization_Departments 
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment 
			WHERE UserNo = drive_getpemissioncommonfoldersbyuser.p_uno or  DepartNo = drive_getpemissioncommonfoldersbyuser.p_dno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) ;
	insert into DepartNos
	RETURN QUERY
	select DepartNo from name_tree

	RETURN QUERY
	SELECT SharingNo, FolderNo, UserNo, DepartNo
	FROM Drive_PemissionCommonFolders
	WHERE UserNo = drive_getpemissioncommonfoldersbyuser.p_uno Or DepartNo in(SELECT DepartNo FROM DepartNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
