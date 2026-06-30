-- ─── FUNCTION: drive_getallfilecommons ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getallfilecommons(integer);
CREATE OR REPLACE FUNCTION public.drive_getallfilecommons(
    p_uno integer
) RETURNS TABLE(
    folderno text
)
AS $function$
BEGIN


   DepartNo int,  
   DepartName varchar(1000),  
   Position varchar(1000),  
   Duties varchar(1000)
  ) ;;
INSERT INTO TEMP_DEPARTMENT  
  EXEC Organization_GetDepartmentNameByUser p_uno,'EN' ;
--1. my
	--common folder
 WITH cte AS 
 (
	  SELECT FolderNo
	  FROM Drive_Folders a
	  WHERE FolderNo in(
				SELECT CF.FolderNo 
				FROM Drive_CommonFolders  CF
				WHERE CF.FolderNo IN (
					SELECT SFCF.FolderNo FROM Drive_SharingForCommonFolders  SFCF
					WHERE SFCF.DepartNo IN (SELECT DepartNo FROM TEMP_DEPARTMENT) OR UserNo = drive_getallfilecommons.p_uno
				)
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
			,'common/' || public."Drive_GetPath"(F.FolderNo) as pathroot
			,COALESCE(F.Note,'') Note
	FROM Drive_Files F
	LEFT JOIN (SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment GROUP BY UserNo) B ON B.UserNo = F.UserNo
	LEFT JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE F.FolderNo IN
	 (
		SELECT FolderNo FROM cte 
	 ) 
	 
	 AND F.IsDeleted = FALSE
	ORDER BY DateCreated DESC

END;

--exec Drive_GetAllFileCommons 70
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
