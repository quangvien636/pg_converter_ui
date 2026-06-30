-- ─── PROCEDURE→FUNCTION: drive_getallfileshareds ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getallfileshareds(integer);
CREATE OR REPLACE FUNCTION public.drive_getallfileshareds(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

--2.share 

WITH cte AS 
 (
  SELECT FolderNo
  FROM Drive_Folders a
  WHERE FolderNo in(
	    SELECT DISTINCT F.FolderNo
		FROM Drive_Folders  F
		INNER JOIN Drive_SharingForFolders  SFF ON SFF.FolderNo = F.FolderNo
		WHERE F.UserNo = drive_getallfileshareds.p_uno
  )
  UNION ALL
  SELECT a.FolderNo
  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo  AND IsDeleted = FALSE
  )

	RETURN QUERY
	SELECT F.FileNo, F.UserNo, F.DateCreated, F.DateModified, F.DateAccessed, F.Name, F.Length, F.FolderNo, F.IsDeleted
			,COALESCE(U.Name,'') AS UserName, U.Name_EN as UserName_EN
			,COALESCE(D.Name,'') AS DepartName, D.Name_EN AS DepartName_EN
			,COALESCE(P.Name,'') AS PositionName, P.Name_EN AS PositionName_EN
			,public."Drive_GetPath"(F.FolderNo) as pathroot
			,COALESCE(F.Note,'') Note
	FROM Drive_Files F
	LEFT JOIN (SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment GROUP BY UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE F.FolderNo IN
	 (
		SELECT FolderNo FROM cte 
	 ) 
	 AND F.IsDeleted = FALSE
	ORDER BY DateCreated DESC

END;

--exec Drive_GetAllFileShareds 70
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
