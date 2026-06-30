-- ─── FUNCTION: drive_gettopcommonfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_gettopcommonfolders(integer);
CREATE OR REPLACE FUNCTION public.drive_gettopcommonfolders(
    userno integer
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN


	with name_tree as 
	(
 		SELECT d.DepartNo, d.ParentNo
		FROM Organization_Departments d
		WHERE d.DepartNo IN (
			SELECT b.DepartNo FROM Organization_BelongToDepartment  b
			WHERE b.UserNo = drive_gettopcommonfolders.userno
		)
	   union all
	   select C.DepartNo, C.ParentNo
	   from Organization_Departments c
	   join name_tree p on C.DepartNo = P.ParentNo  
		AND C.DepartNo<>C.ParentNo 
	) 

	RETURN QUERY
	SELECT CF.CommonNo, CF.MaxLength, CF.FolderNo, F.DateCreated, F.DateModified, F.Name, F.Length, F.ParentNo, F.IsDeleted
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
	WHERE CF.FolderNo IN (
		SELECT SFCF.FolderNo FROM Drive_SharingForCommonFolders SFCF
		WHERE SFCF.DepartNo IN (SELECT DepartNo FROM name_tree) OR UserNo = drive_gettopcommonfolders.userno
	)
	and COALESCE(f.ParentNo,0) = 0 -- not load for child if top
	ORDER BY COALESCE(F.Sort,0) ASC, F.DateModified ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
