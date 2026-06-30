-- ─── FUNCTION: drive_getfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getfile(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfile(
    fileno bigint
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT F.FileNo, F.UserNo, F.DateCreated, F.DateModified, F.DateAccessed, F.Name, F.Length, F.FolderNo, F.IsDeleted
		  ,COALESCE(f.Note,'') Note
		  ,COALESCE(U.Name,'') AS UserName, COALESCE(U.Name_EN,'') as UserName_EN
		  ,COALESCE(D.Name,'') AS DepartName, COALESCE(D.Name_EN,'') AS DepartName_EN, D.DepartNo
		  ,COALESCE(P.Name,'') AS PositionName, COALESCE(P.Name_EN,'') AS PositionName_EN
	FROM Drive_Files F
	LEFT JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, UserNo from  Organization_BelongToDepartment group by UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE F.FileNo = drive_getfile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
