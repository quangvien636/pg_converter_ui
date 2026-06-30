-- ─── PROCEDURE→FUNCTION: organization_getdepartmentnamebyuserwoori ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getdepartmentnamebyuserwoori(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentnamebyuserwoori(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    listofdepartnos table (
	departno	int,
	departname nvarchar(200);
    belongtodepartments table (
			rownum		int identity,
			departno	int,
			parentno	int,
			name nvarchar(200);
    departtemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




)
	    

		)
		-- add return :duties,posision 
		,
			Duties nvarchar(200),
			Posision nvarchar(200)
		)

		SELECT  INTO  FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = organization_getdepartmentnamebyuserwoori.userno
		)
		
		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo,(case when LangCode = 'EN' THEN Name_EN else Name end) as Name FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = organization_getdepartmentnamebyuserwoori.userno
		)


		RowIndex := 1;
		MaxIndex := (SELECT MAX(RowNum) FROM BelongToDepartments);


		WHILE RowIndex <= MaxIndex LOOP

			SELECT DepartNo, ParentNo INTO departno, parentno FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo,DepartName

			WHILE ParentNo != 0 LOOP

				SELECT DepartNo, ParentNo, (case when LangCode = 'EN' THEN Name_EN else Name end) INTO departno, parentno, departname FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo,DepartName

			END LOOP;

			RowIndex := RowIndex + 1;
		END LOOP;



			SELECT (case when LangCode = 'EN' THEN D.Name_EN else D.Name end) INTO duty FROM Organization_BelongToDepartment BD -- Users 
				INNER JOIN Organization_Duties D ON BD.DutyNo = D.DutyNo -- Duties
				INNER JOIN Organization_Positions P ON BD.PositionNo = P.PositionNo -- Position
			WHERE BD.UserNo = organization_getdepartmentnamebyuserwoori.userno AND DepartNo = DepartTemp

	INSERT INTO BelongToDepartmentsReturn
	RETURN QUERY
	SELECT D.DepartNo,D.DepartName,Duty,Position
	FROM ListOfDepartNos D
	RETURN QUERY
	select * from BelongToDepartmentsReturn;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
