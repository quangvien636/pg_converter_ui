-- ─── FUNCTION: drive_getfoldersandfilesfromtrash ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getfoldersandfilesfromtrash(integer);
CREATE OR REPLACE FUNCTION public.drive_getfoldersandfilesfromtrash(
    userno integer
) RETURNS TABLE(
    col1 text,
    col2 text,
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT F.FolderNo, F.UserNo, F.DateCreated, F.DateModified, F.Name, F.Length, F.ParentNo, F.IsDeleted,
		T.ItemNo, T.DateDeleted, T.FullPath
			,COALESCE(U.Name,'') AS UserName, U.Name_EN as UserName_EN
			,COALESCE(D.Name,'') AS DepartName, D.Name_EN AS DepartName_EN
			,COALESCE(P.Name,'') AS PositionName, P.Name_EN AS PositionName_EN
	FROM Drive_Folders  AS F
	INNER JOIN Drive_Trash  AS T ON T.UserNo = drive_getfoldersandfilesfromtrash.userno AND T.FolderNo = F.FolderNo
	LEFT JOIN (SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment GROUP BY UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo

	RETURN QUERY
	SELECT F.FileNo, F.UserNo, F.DateCreated, F.DateModified, F.DateAccessed, F.Name, F.Length, F.FolderNo, F.IsDeleted,
		T.ItemNo, T.DateDeleted, T.FullPath
			,COALESCE(U.Name,'') AS UserName, U.Name_EN as UserName_EN
			,COALESCE(D.Name,'') AS DepartName, D.Name_EN AS DepartName_EN
			,COALESCE(P.Name,'') AS PositionName, P.Name_EN AS PositionName_EN
	FROM Drive_Files  AS F
	INNER JOIN Drive_Trash  AS T ON T.UserNo = drive_getfoldersandfilesfromtrash.userno AND T.FileNo = F.FileNo
	LEFT JOIN (SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment GROUP BY UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
