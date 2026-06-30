-- ─── FUNCTION: drive_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfiles(
    folderno bigint
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT F.FileNo, F.UserNo, F.DateCreated, F.DateModified, F.DateAccessed, F.Name, F.Length, F.FolderNo, F.IsDeleted, COALESCE(F.Note,'') Note
		,U.Name AS UserName, U.Name_EN as UserName_EN
		,D.Name AS DepartName, D.Name_EN AS DepartName_EN
		,P.Name AS PositionName, P.Name_EN AS PositionName_EN
	FROM Drive_Files F
	INNER JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, UserNo from  Organization_BelongToDepartment group by UserNo) B ON B.UserNo = F.UserNo
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE F.FolderNo = drive_getfiles.folderno AND F.IsDeleted = FALSE
	ORDER BY F.DateCreated DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
