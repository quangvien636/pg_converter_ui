-- ─── FUNCTION: organization_getalluserswithbelongs ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getalluserswithbelongs(boolean);
CREATE OR REPLACE FUNCTION public.organization_getalluserswithbelongs(
    alsodisabled boolean
) RETURNS TABLE(
    usersortno text,
    belongno text,
    userno text,
    name text,
    isdefault text,
    departno text,
    departname text,
    departname_en text,
    departsortno text,
    positionno text,
    positionname text,
    positionname_en text,
    positionsortno text,
    dutyno text,
    dutyname text,
    dutyname_en text,
    dutysortno text,
    name_ch text,
    name_jp text,
    name_vn text,
    departname_ch text,
    departname_jp text,
    departname_vn text,
    positionname_ch text,
    positionname_jp text,
    positionname_vn text,
    dutyname_ch text,
    dutyname_jp text,
    dutyname_vn text
)
AS $function$
DECLARE
    sorting table (
		rowidx	int identity,
		userno	int
	);
BEGIN



	INSERT INTO Sorting
	RETURN QUERY
	SELECT UserNo FROM Organization_SortingEachDepartment --WHERE DepartNo = 11110




		RowIdx			INT IDENTITY,
		UserNo			INT,
		ModUserNo		INT,
		ModDate			DATETIME,
		UserID			VARCHAR(100),
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

	IF (AlsoDisabled = 0) BEGIN

		INSERT INTO ListOfUsers
		RETURN QUERY
		SELECT B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN
			, U.Name_CH, U.Name_JP, U.Name_VN
			, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
			P.SortNo AS PositionSortNo, U.BirthDate, U.EntranceDate
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		WHERE B.IsDefault = TRUE
		ORDER BY P.SortNo ASC, U.Name ASC

	END
	
	ELSE BEGIN
	
		INSERT INTO ListOfUsers
		RETURN QUERY
		SELECT B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN
		, U.Name_CH, U.Name_JP, U.Name_VN
		, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
			P.SortNo AS PositionSortNo, U.BirthDate, U.EntranceDate
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.IsVirtual = FALSE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		WHERE B.IsDefault = TRUE
		ORDER BY P.SortNo ASC, U.Name ASC
		
	END

	IF (SELECT COUNT(*) FROM Sorting) = 0 BEGIN

		RETURN QUERY
		SELECT UserNo, ModUserNo, ModDate, UserID, Name, Name_EN
		, Name_CH, Name_JP, Name_VN
		, MailAddress, CellPhone, CompanyPhone, UserPhoto, Photo, Enabled,
			PositionSortNo, BirthDate, EntranceDate
		FROM ListOfUsers

	END

	ELSE BEGIN


			RowIdx			INT,
			UserNo			INT,
			ModUserNo		INT,
			ModDate			DATETIME,
			UserID			VARCHAR(100),
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
		SELECT RowIdx, UserNo, ModUserNo, ModDate, UserID, Name, Name_EN
		, Name_CH, Name_JP, Name_VN
		, MailAddress, CellPhone, CompanyPhone, UserPhoto,
			Photo, Enabled, PositionSortNo, BirthDate, EntranceDate,PositionSortNo	
		FROM ListOfUsers2 C
		ORDER BY RowIdx asc ,c.PositionSortNo asc

	END
	
	RETURN QUERY
	SELECT DISTINCT 
		ROW_NUMBER() OVER( ORDER BY COALESCE(S.SortNo,9999) , P.SortNo , U.Name ) AS UserSortNo,
		B.BelongNo, B.UserNo,U.Name, B.IsDefault,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
		COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo
		,U.Name_CH,U.Name_JP,U.Name_VN
		,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
		,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
		,COALESCE(DT.Name_CH, '') AS DutyName_CH,COALESCE(DT.Name_JP, '') AS DutyName_JP,COALESCE(DT.Name_VN, '') AS DutyName_VN
	FROM Organization_BelongToDepartment B
	inner JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	inner JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	inner JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	left JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
	LEFT JOIN Organization_SortingEachDepartment S  ON S.UserNo = U.UserNo and S.DepartNo = D.DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
