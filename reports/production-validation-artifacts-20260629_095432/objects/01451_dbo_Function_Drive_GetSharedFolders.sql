-- ─── FUNCTION: drive_getsharedfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getsharedfolders(integer);
CREATE OR REPLACE FUNCTION public.drive_getsharedfolders(
    userno integer
) RETURNS TABLE(
    col1 text,
    col2 text,
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DISTINCT  F.FolderNo, F.UserNo, F.DateCreated, F.DateModified, F.Name, F.Length, F.ParentNo, F.IsDeleted
					,U.Name AS UserName, U.Name_EN as UserName_EN
					,D.Name AS DepartName, D.Name_EN AS DepartName_EN
					,P.Name AS PositionName, P.Name_EN AS PositionName_EN
					, COALESCE(F.Sort,0) Sort
	FROM Drive_Folders  F
	INNER JOIN Drive_SharingForFolders  SFF ON SFF.FolderNo = F.FolderNo
	LEFT JOIN (SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment GROUP BY UserNo) B ON B.UserNo = F.UserNo
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE F.UserNo = drive_getsharedfolders.userno
	ORDER BY COALESCE(F.Sort,0) ASC, F.DateModified ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
