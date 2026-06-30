-- ─── PROCEDURE→FUNCTION: organization_getallusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getallusers(boolean);
CREATE OR REPLACE FUNCTION public.organization_getallusers(
    IN alsodisabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    sorting table (
		rowidx	int identity,
		userno	int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	INSERT INTO Sorting
	RETURN QUERY
	SELECT UserNo FROM Organization_SortingEachDepartment WHERE DepartNo = 0
	
	,
		Name			NVARCHAR(100),
		Name_EN			NVARCHAR(100),
		MailAddress		NVARCHAR(200),
		CellPhone		VARCHAR(100),
		CompanyPhone	VARCHAR(100),
		ExtensionNumber	VARCHAR(100),
		UserPhoto		BIT,
		Photo			NVARCHAR(500),
		Enabled		BIT,
		DepartNo		INT,
		DepartName		NVARCHAR(100),
		ShortName		NVARCHAR(100),
		DepartName_EN	NVARCHAR(100),
		DepartSortNo	INT,
		PositionNo		INT,
		PositionName	NVARCHAR(100),
		PositionName_EN	NVARCHAR(100),
		PositionSortNo	INT,
		DutyNo			INT,
		DutyName		NVARCHAR(100),
		DutyName_EN		NVARCHAR(100),
		DutySortNo		INT,
		BirthDate		DATETIME,
		BirthDateType	INT,

		Name_CH			NVARCHAR(100),
		Name_JP			NVARCHAR(100),
		Name_VN			NVARCHAR(100),

		DepartName_CH	NVARCHAR(100),
		DepartName_JP	NVARCHAR(100),
		DepartName_VN	NVARCHAR(100),
		
		PositionName_CH	NVARCHAR(100),
		PositionName_JP	NVARCHAR(100),
		PositionName_VN	NVARCHAR(100),

		DutyName_CH		NVARCHAR(100),
		DutyName_JP		NVARCHAR(100),
		DutyName_VN		NVARCHAR(100)
	)

	IF AlsoDisabled = 0 THEN

		INSERT INTO ListOfUsers
		RETURN QUERY
		SELECT B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone,U.ExtensionNumber ,U.UserPhoto, U.Photo, U.Enabled,
			D.DepartNo, D.Name AS DepartName, D.ShortName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
			P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
			COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo,
			U.BirthDate,U.BirthDateType
			,U.Name_CH,U.Name_JP,U.Name_VN
			,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
			,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
			,COALESCE(DT.Name_CH, '') AS DutyName_CH,COALESCE(DT.Name_JP, '') AS DutyName_JP,COALESCE(DT.Name_VN, '') AS DutyName_VN
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE B.IsDefault = TRUE
		ORDER BY P.SortNo ASC, U.Name ASC

	END IF;
	
	ELSE BEGIN
	
		INSERT INTO ListOfUsers
		RETURN QUERY
		SELECT B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone,U.ExtensionNumber , U.UserPhoto, U.Photo, U.Enabled,
			D.DepartNo, D.Name AS DepartName,D.ShortName ,D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
			P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
			COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo,
			U.BirthDate,U.BirthDateType
			,U.Name_CH,U.Name_JP,U.Name_VN
			,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
			,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
			,COALESCE(DT.Name_CH, '') AS DutyName_CH,COALESCE(DT.Name_JP, '') AS DutyName_JP,COALESCE(DT.Name_VN, '') AS DutyName_VN
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.IsVirtual = FALSE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE B.IsDefault = TRUE
		ORDER BY P.SortNo ASC, U.Name ASC
		
	END;

	IF (SELECT COUNT(*) FROM Sorting) = 0 THEN

		RETURN QUERY
		SELECT UserNo, ModUserNo, ModDate, UserID, Name, Name_EN, MailAddress, CellPhone, CompanyPhone,ExtensionNumber, UserPhoto, Photo,
			Enabled, DepartNo, DepartName,ShortName, DepartName_EN, DepartSortNo, PositionNo, PositionName, PositionName_EN, PositionSortNo,
			DutyNo, DutyName, DutyName_EN, DutySortNo, BirthDate,BirthDateType
			,Name_CH,Name_JP	,Name_VN,DepartName_CH,DepartName_JP,DepartName_VN,PositionName_CH,PositionName_JP,PositionName_VN,DutyName_CH,
			DutyName_JP	,DutyName_VN
		FROM ListOfUsers
		ORDER BY RowIdx ASC

	END IF;

	ELSE BEGIN

		,
			Name			NVARCHAR(100),
			Name_EN			NVARCHAR(100),
			MailAddress		NVARCHAR(200),
			CellPhone		VARCHAR(100),
			CompanyPhone	VARCHAR(100),
			ExtensionNumber	VARCHAR(100),
			UserPhoto		BIT,
			Photo			NVARCHAR(500),
			Enabled		BIT,
			DepartNo		INT,
			DepartName		NVARCHAR(100),
			ShortName		NVARCHAR(100),
			DepartName_EN	NVARCHAR(100),
			DepartSortNo	INT,
			PositionNo		INT,
			PositionName	NVARCHAR(100),
			PositionName_EN	NVARCHAR(100),
			PositionSortNo	INT,
			DutyNo			INT,
			DutyName		NVARCHAR(100),
			DutyName_EN		NVARCHAR(100),
			DutySortNo		INT,
			BirthDate		DATETIME,
			BirthDateType	INT,

			Name_CH			NVARCHAR(100),
			Name_JP			NVARCHAR(100),
			Name_VN			NVARCHAR(100),

			DepartName_CH	NVARCHAR(100),
			DepartName_JP	NVARCHAR(100),
			DepartName_VN	NVARCHAR(100),
		
			PositionName_CH	NVARCHAR(100),
			PositionName_JP	NVARCHAR(100),
			PositionName_VN	NVARCHAR(100),

			DutyName_CH		NVARCHAR(100),
			DutyName_JP		NVARCHAR(100),
			DutyName_VN		NVARCHAR(100)
		)

		INSERT INTO ListOfUsers2 
		RETURN QUERY
		SELECT S.RowIdx, L.UserNo, L.ModUserNo, L.ModDate, L.UserID, L.Name, L.Name_EN, L.MailAddress, L.CellPhone, L.CompanyPhone,L.ExtensionNumber, L.UserPhoto, L.Photo,
			L.Enabled, L.DepartNo, L.DepartName,L.ShortName, L.DepartName_EN, L.DepartSortNo, L.PositionNo, L.PositionName, L.PositionName_EN, L.PositionSortNo,
			L.DutyNo, L.DutyName, L.DutyName_EN, L.DutySortNo, L.BirthDate,L.BirthDateType
			,L.Name_CH,L.Name_JP,L.Name_VN,L.DepartName_CH,L.DepartName_JP,L.DepartName_VN,L.PositionName_CH,
			L.PositionName_JP,L.PositionName_VN,L.DutyName_CH,L.DutyName_JP	,L.DutyName_VN	
		FROM ListOfUsers AS L 
		LEFT JOIN Sorting AS S ON S.UserNo = L.UserNo

		UPDATE ListOfUsers2 SET RowIdx = (SELECT MAX(RowIdx) FROM ListOfUsers2 A WHERE A.PositionSortNo >= PositionSortNo)
		WHERE RowIdx IS NULL

		RETURN QUERY
		SELECT UserNo, ModUserNo, ModDate, UserID, Name, Name_EN, MailAddress, CellPhone, CompanyPhone,ExtensionNumber ,UserPhoto, Photo,
			Enabled, DepartNo, DepartName, ShortName ,DepartName_EN, DepartSortNo, PositionNo, PositionName, PositionName_EN, PositionSortNo,
			DutyNo, DutyName, DutyName_EN, DutySortNo, BirthDate , BirthDateType
			,Name_CH,Name_JP	,Name_VN,DepartName_CH,DepartName_JP,DepartName_VN,PositionName_CH,PositionName_JP,PositionName_VN,DutyName_CH,
			DutyName_JP	,DutyName_VN
		FROM ListOfUsers2
		ORDER BY RowIdx ASC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
