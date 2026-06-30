-- ─── PROCEDURE→FUNCTION: organization_getalluserswithbelongs_mod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getalluserswithbelongs_mod(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_getalluserswithbelongs_mod(
    IN moddate timestamp without time zone
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
		Name_CH			NVARCHAR(100),
		Name_JP			NVARCHAR(100),
		Name_VN			NVARCHAR(100),
		MailAddress		NVARCHAR(200),
		CellPhone		VARCHAR(100),
		CompanyPhone	VARCHAR(100),
		UserPhoto		BIT,
		Photo			NVARCHAR(500),
		Enabled		BIT,
		PositionSortNo	INT,
		BirthDate		DATETIME,
		EntranceDate	DATETIME
	)

	INSERT INTO ListOfUsers
	RETURN QUERY
	SELECT B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN
		, U.Name_CH, U.Name_JP, U.Name_VN
		, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
		P.SortNo AS PositionSortNo, U.BirthDate, U.EntranceDate
	FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.IsVirtual = FALSE
	AND U.ModDate > organization_getalluserswithbelongs_mod.moddate
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	WHERE B.IsDefault = TRUE
	ORDER BY U.Name ASC



	IF (SELECT COUNT(*) FROM Sorting) = 0 THEN

		RETURN QUERY
		SELECT UserNo, ModUserNo, ModDate, UserID, Name, Name_EN
		, Name_CH, Name_JP, Name_VN
		, MailAddress, CellPhone, CompanyPhone, UserPhoto, Photo, Enabled,
			PositionSortNo, BirthDate, EntranceDate
		FROM ListOfUsers

	END IF;

	ELSE BEGIN

		,
			Name			NVARCHAR(100),
			Name_EN			NVARCHAR(100),
			Name_CH			NVARCHAR(100),
			Name_JP			NVARCHAR(100),
			Name_VN			NVARCHAR(100),
			MailAddress		NVARCHAR(200),
			CellPhone		VARCHAR(100),
			CompanyPhone	VARCHAR(100),
			UserPhoto		BIT,
			Photo			NVARCHAR(500),
			Enabled		BIT,
			PositionSortNo	INT,
			BirthDate		DATETIME,
			EntranceDate	DATETIME
		)

		INSERT INTO ListOfUsers2 
		RETURN QUERY
		SELECT S.RowIdx, L.UserNo, L.ModUserNo, L.ModDate, L.UserID, L.Name, L.Name_EN
		, L.Name_CH, L.Name_JP, L.Name_VN
		, L.MailAddress, L.CellPhone, L.CompanyPhone, L.UserPhoto, L.Photo, L.Enabled,
			L.PositionSortNo, L.BirthDate, L.EntranceDate
		FROM ListOfUsers AS L
		LEFT JOIN Sorting AS S ON S.UserNo = L.UserNo

		UPDATE ListOfUsers2 SET RowIdx = (SELECT MAX(RowIdx) FROM ListOfUsers2 A WHERE A.PositionSortNo >= PositionSortNo)
		WHERE RowIdx IS NULL

		RETURN QUERY
		SELECT UserNo, ModUserNo, ModDate, UserID, Name, Name_EN
		, Name_CH, Name_JP, Name_VN
		, MailAddress, CellPhone, CompanyPhone, UserPhoto,
			Photo, Enabled, PositionSortNo, BirthDate, EntranceDate	
		FROM ListOfUsers2
		ORDER BY RowIdx ASC

	END;
	
	RETURN QUERY
	SELECT DISTINCT B.BelongNo, B.UserNo, B.IsDefault,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
		COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo
		,U.Name_CH,U.Name_JP,U.Name_VN
		,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
		,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
		,COALESCE(DT.Name_CH, '') AS DutyName_CH,COALESCE(DT.Name_JP, '') AS DutyName_JP,COALESCE(DT.Name_VN, '') AS DutyName_VN
	FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.IsVirtual = FALSE
	AND U.ModDate > organization_getalluserswithbelongs_mod.moddate
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
