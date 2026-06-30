-- ─── FUNCTION: drive_getcommonfolderlength ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getcommonfolderlength(integer);
CREATE OR REPLACE FUNCTION public.drive_getcommonfolderlength(
    p_no integer
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    userno text
)
AS $function$
BEGIN



	RETURN QUERY
	SELECT CF.CommonNo, CF.MaxLength, CF.FolderNo, F.DateCreated, F.DateModified, F.Name
		   , Length = public."Drive_GetLength"(F.FolderNo) 
			, F.ParentNo, F.IsDeleted
			,COALESCE(U.Name,'') AS UserName, COALESCE(U.Name_EN,'') as UserName_EN
			,COALESCE(D.Name,'') AS DepartName, COALESCE(D.Name_EN,'') AS DepartName_EN, D.DepartNo, F.UserNo
			,COALESCE(P.Name,'') AS PositionName, COALESCE(P.Name_EN,'') AS PositionName_EN
			, COALESCE(F.Note,'') Note
			,COALESCE(F.Sort,0) Sort
	FROM Drive_CommonFolders  CF
	INNER JOIN Drive_Folders  F ON F.FolderNo = CF.FolderNo
	LEFT JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, UserNo from  Organization_BelongToDepartment group by UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE CF.FolderNo = drive_getcommonfolderlength.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
