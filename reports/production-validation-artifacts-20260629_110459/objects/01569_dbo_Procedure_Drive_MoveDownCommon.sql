-- ─── PROCEDURE→FUNCTION: drive_movedowncommon ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_movedowncommon(bigint, integer);
CREATE OR REPLACE FUNCTION public.drive_movedowncommon(
    IN p_fno bigint,
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	with name_tree as 
		(
 			SELECT d.DepartNo, d.ParentNo
			FROM Organization_Departments d
			WHERE d.DepartNo IN (
				SELECT b.DepartNo FROM Organization_BelongToDepartment  b
				WHERE b.UserNo = drive_movedowncommon.p_uno
			)
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.DepartNo = P.ParentNo  
			AND C.DepartNo<>C.ParentNo 
		),
	 cte As
	 (
		SELECT F.FolderNo
				,F.sort
				,ROW_NUMBER() OVER (ORDER BY COALESCE(f.Sort,0) ASC, f.DateModified ASC) AS RN
		FROM Drive_CommonFolders  CF
		INNER JOIN Drive_Folders  F ON F.FolderNo = CF.FolderNo
		WHERE CF.FolderNo IN (
			SELECT SFCF.FolderNo FROM Drive_SharingForCommonFolders SFCF
			WHERE SFCF.DepartNo IN (SELECT DepartNo FROM name_tree) OR UserNo = drive_movedowncommon.p_uno
		)
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE Drive_Folders set Sort = Sort + 1.01 Where FolderNo =  drive_movedowncommon.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
