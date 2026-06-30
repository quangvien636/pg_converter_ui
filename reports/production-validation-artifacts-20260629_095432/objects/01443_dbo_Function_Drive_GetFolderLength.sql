-- ─── FUNCTION: drive_getfolderlength ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getfolderlength(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfolderlength(
    p_no bigint
) RETURNS void
AS $function$
BEGIN


		WITH cte AS 
	 (
		  SELECT FolderNo, ParentNo
		  FROM Drive_Folders a
		  WHERE FolderNo = drive_getfolderlength.p_no
		  UNION ALL
		  SELECT a.FolderNo, a.ParentNo
		  FROM Drive_Folders a JOIN cte c ON a.ParentNo = c.FolderNo -- AND IsDeleted = FALSE
	  ) 
	select * into #tam2 from cte
	SELECT f.FolderNo, f.UserNo, f.DateCreated, f.DateModified, f.Name
		  , Length = (select SUM(Length) from Drive_Files
						where FolderNo in ( select FolderNo from #tam2))
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
	WHERE FolderNo = drive_getfolderlength.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
