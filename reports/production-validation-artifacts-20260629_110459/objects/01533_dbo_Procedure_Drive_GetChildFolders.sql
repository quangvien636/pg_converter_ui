-- ─── PROCEDURE→FUNCTION: drive_getchildfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.drive_getchildfolders(bigint);
CREATE OR REPLACE FUNCTION public.drive_getchildfolders(
    IN folderno bigint
) RETURNS void
AS $function$
BEGIN


	CREATE TEMP TABLE tam AS SELECT f.FolderNo, f.UserNo, f.DateCreated, f.DateModified, f.Name, f.Length, f.ParentNo, f.IsDeleted
			,COALESCE(U.Name,'') AS UserName, COALESCE(U.Name_EN,'') as UserName_EN
			,COALESCE(D.Name,'') AS DepartName, COALESCE(D.Name_EN,'') AS DepartName_EN, D.DepartNo
			,COALESCE(P.Name,'') AS PositionName, COALESCE(P.Name_EN,'') AS PositionName_EN
			, F.SORT
			, COALESCE(F.Note,'') Note FROM Drive_Folders f
	LEFT JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, UserNo from  Organization_BelongToDepartment group by UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE f.ParentNo = drive_getchildfolders.folderno AND f.IsDeleted = FALSE

	SELECT R.*,
		CASE
			WHEN (SELECT COUNT(*) FROM Drive_SharingForFolders WHERE FolderNo = R.FolderNo) = 0 THEN FALSE
			ELSE TRUE
		END AS IsShared
	FROM tam AS R
	ORDER BY COALESCE(R.Sort,0) ASC, R.DateModified ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
