-- ─── FUNCTION: drive_getfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfolder(
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
	SELECT f.FolderNo, f.UserNo, f.DateCreated, f.DateModified, f.Name
		, Length = public."Drive_GetLength"(F.FolderNo) 
		, f.ParentNo, f.IsDeleted
		  ,COALESCE(f.Note,'') Note
		  ,COALESCE(U.Name,'') AS UserName, COALESCE(U.Name_EN,'') as UserName_EN
		  ,COALESCE(D.Name,'') AS DepartName, COALESCE(D.Name_EN,'') AS DepartName_EN, D.DepartNo
		  ,COALESCE(P.Name,'') AS PositionName, COALESCE(P.Name_EN,'') AS PositionName_EN
	FROM Drive_Folders f
	LEFT JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, UserNo from  Organization_BelongToDepartment group by UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE FolderNo = drive_getfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
