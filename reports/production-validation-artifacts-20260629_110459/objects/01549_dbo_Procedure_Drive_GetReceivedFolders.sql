-- ─── PROCEDURE→FUNCTION: drive_getreceivedfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getreceivedfolders(integer);
CREATE OR REPLACE FUNCTION public.drive_getreceivedfolders(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    listofdepartnos table (
		departno	int
	);
    belongtodepartments table (
		rownum		int identity,
		departno	int,
		parentno	int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	INSERT INTO BelongToDepartments
	RETURN QUERY
	SELECT DepartNo, ParentNo FROM Organization_Departments
	WHERE DepartNo IN (
		SELECT DepartNo FROM Organization_BelongToDepartment
		WHERE UserNo = drive_getreceivedfolders.userno
	)


	RowIndex := 1;
	MaxIndex := (SELECT MAX(RowNum) FROM BelongToDepartments);


	WHILE RowIndex <= MaxIndex LOOP

		SELECT DepartNo INTO departno FROM BelongToDepartments
		WHERE RowNum = RowIndex

		INSERT INTO ListOfDepartNos
		RETURN QUERY
		SELECT DepartNo

		WHILE ParentNo != 0 LOOP

			SELECT DepartNo, ParentNo INTO departno, parentno FROM Organization_Departments
			WHERE DepartNo = ParentNo

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo

		END LOOP;

		RowIndex := RowIndex + 1;
	END LOOP;

	RETURN QUERY
	SELECT f.FolderNo, f.UserNo, f.DateCreated, f.DateModified, f.Name, f.Length, f.ParentNo, f.IsDeleted
		,U.Name AS UserName, U.Name_EN as UserName_EN
		,D.Name AS DepartName, D.Name_EN AS DepartName_EN
		,P.Name AS PositionName, P.Name_EN AS PositionName_EN
		,COALESCE(F.NOTE,'') NOTE
	FROM Drive_Folders  f
	INNER JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, UserNo from  Organization_BelongToDepartment group by UserNo) B ON B.UserNo = F.UserNo
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo 
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	WHERE f.UserNo != drive_getreceivedfolders.userno AND f.FolderNo IN (
		SELECT FolderNo
		FROM Drive_SharingForFolders 
		WHERE UserNo = drive_getreceivedfolders.userno OR DepartNo IN (SELECT DepartNo FROM ListOfDepartNos)
	)
	ORDER BY COALESCE(F.Sort,0) , F.DateModified ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
