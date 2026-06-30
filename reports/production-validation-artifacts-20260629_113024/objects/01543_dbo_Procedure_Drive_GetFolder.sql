-- ─── PROCEDURE→FUNCTION: drive_getfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfolder(
    IN folderno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
