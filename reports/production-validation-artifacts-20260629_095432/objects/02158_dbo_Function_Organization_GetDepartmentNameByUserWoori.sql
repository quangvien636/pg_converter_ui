-- ─── FUNCTION: organization_getdepartmentnamebyuserwoori ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartmentnamebyuserwoori(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentnamebyuserwoori(
    userno integer
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
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
BEGIN




)
	    

		)
		-- add return :duties,posision 

			DepartNo	INT,
			DepartName nvarchar(200),
			Duties nvarchar(200),
			Posision nvarchar(200)
		)

		SELECT DepartTemp=DepartNo 
		FROM Organization_Departments
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


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM BelongToDepartments)



		WHILE (RowIndex <= MaxIndex) BEGIN

			SELECT DepartNo = DepartNo, ParentNo = ParentNo, DepartName = Name
			FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo,DepartName

			WHILE (ParentNo != 0) BEGIN

				SELECT DepartNo = DepartNo, ParentNo = ParentNo,DepartName=(case when LangCode = 'EN' THEN Name_EN else Name end) FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo,DepartName

			END

			SET RowIndex = RowIndex + 1

		END



			SELECT Duty=(case when LangCode = 'EN' THEN D.Name_EN else D.Name end) ,Position= (case when LangCode = 'EN' THEN P.Name_EN else P.Name end) -- Position Name
			FROM Organization_BelongToDepartment BD -- Users 
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
