-- ─── FUNCTION: organization_getallusers_tosearch_paging ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getallusers_tosearch_paging(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_getallusers_tosearch_paging(
    currentpageindex integer,
    pagepercount integer,
    alsodisabled boolean
) RETURNS TABLE(
    rownum text,
    rowidx text,
    userno text,
    moduserno text,
    moddate text,
    userid text,
    name text,
    name_en text,
    mailaddress text,
    cellphone text,
    companyphone text,
    extensionnumber text,
    userphoto text,
    photo text,
    enabled text,
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
    birthdate text,
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
	SELECT UserNo FROM Organization_SortingEachDepartment WHERE DepartNo = 0
	

		RowIdx			INT IDENTITY,
		UserNo			INT,
		ModUserNo		INT,
		ModDate			DATETIME,
		UserID			VARCHAR(100),
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

	IF (AlsoDisabled = 0) BEGIN

		INSERT INTO ListOfUsers
		RETURN QUERY
		SELECT 
			B.UserNo, 
			U.ModUserNo, 
			U.ModDate, 
			U.UserID, 
			U.Name, 
			U.Name_EN, 
			U.MailAddress, 
			U.CellPhone, 
			U.CompanyPhone, 
			U.ExtensionNumber,
			U.UserPhoto, 
			U.Photo, 
			U.Enabled,
			D.DepartNo, 
			D.Name AS DepartName, 
			D.Name_EN AS DepartName_EN, 
			D.SortNo AS DepartSortNo,
			P.PositionNo, 
			P.Name AS PositionName, 
			P.Name_EN AS PositionName_EN, 
			P.SortNo AS PositionSortNo,
			COALESCE(DT.DutyNo, 0) AS DutyNo, 
			COALESCE(DT.Name, '') AS DutyName, 
			COALESCE(DT.Name_EN, '') AS DutyName_EN, 
			COALESCE(DT.SortNo, 9999) AS DutySortNo,
			U.BirthDate,
			U.Name_CH,
			U.Name_JP,
			U.Name_VN,
			D.Name_CH AS DepartName_CH,
			D.Name_JP AS DepartName_JP,
			D.Name_VN AS DepartName_VN,
			P.Name_CH AS PositionName_CH,
			P.Name_JP AS PositionName_JP,
			P.Name_VN AS PositionName_VN,
			COALESCE(DT.Name_CH, '') AS DutyName_CH,
			COALESCE(DT.Name_JP, '') AS DutyName_JP,
			COALESCE(DT.Name_VN, '') AS DutyName_VN
		FROM 
			Organization_BelongToDepartment B
		INNER JOIN 
			Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
		INNER JOIN 
			Organization_Departments D ON D.DepartNo = B.DepartNo
		INNER JOIN 
			Organization_Positions P ON P.PositionNo = B.PositionNo
		LEFT JOIN 
			Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE (U.UserID ILIKE '%' || SearchText || '%' OR U.Name ILIKE '%' || SearchText || '%' OR U.Name_EN ILIKE '%' || SearchText || '%' OR U.MailAddress ILIKE '%' || SearchText || '%')
		ORDER BY 
			P.SortNo ASC, U.Name ASC

	END
	
	ELSE BEGIN
	
		INSERT INTO ListOfUsers
		RETURN QUERY
		SELECT 
			B.UserNo, 
			U.ModUserNo, 
			U.ModDate, 
			U.UserID, 
			U.Name, 
			U.Name_EN, 
			U.MailAddress, 
			U.CellPhone, 
			U.CompanyPhone, 
			U.ExtensionNumber,
			U.UserPhoto, 
			U.Photo, 
			U.Enabled,
			D.DepartNo, 
			D.Name AS DepartName, 
			D.Name_EN AS DepartName_EN, 
			D.SortNo AS DepartSortNo,
			P.PositionNo, 
			P.Name AS PositionName, 
			P.Name_EN AS PositionName_EN, 
			P.SortNo AS PositionSortNo,
			COALESCE(DT.DutyNo, 0) AS DutyNo, 
			COALESCE(DT.Name, '') AS DutyName, 
			COALESCE(DT.Name_EN, '') AS DutyName_EN, 
			COALESCE(DT.SortNo, 9999) AS DutySortNo,
			U.BirthDate,
			U.Name_CH,
			U.Name_JP,
			U.Name_VN,
			D.Name_CH AS DepartName_CH,
			D.Name_JP AS DepartName_JP,
			D.Name_VN AS DepartName_VN,
			P.Name_CH AS PositionName_CH,
			P.Name_JP AS PositionName_JP,
			P.Name_VN AS PositionName_VN,
			COALESCE(DT.Name_CH, '') AS DutyName_CH,
			COALESCE(DT.Name_JP, '') AS DutyName_JP,
			COALESCE(DT.Name_VN, '') AS DutyName_VN
		FROM 
			Organization_BelongToDepartment B
		INNER JOIN 
			Organization_Users U ON U.UserNo = B.UserNo AND U.IsVirtual = FALSE
		INNER JOIN 
			Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN 
			Organization_Departments D ON D.DepartNo = B.DepartNo
		LEFT JOIN 
			Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE (U.UserID ILIKE '%' || SearchText || '%' OR U.Name ILIKE '%' || SearchText || '%' OR U.Name_EN ILIKE '%' || SearchText || '%' OR U.MailAddress ILIKE '%' || SearchText || '%')
		ORDER BY 
			P.SortNo ASC, U.Name ASC
		
	END


	INSERT INTO ListOfUsers
	RETURN QUERY
	SELECT U.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone,U.ExtensionNumber, U.UserPhoto, U.Photo, U.Enabled,
		0, '', '', 9999,
		0, '', '', 9999,
		0, '', '', 9999,
		U.BirthDate
		,U.Name_CH,U.Name_JP,U.Name_VN
		,'','',''
		,'','',''
		,'','',''
	FROM Organization_Users U
	WHERE U.Enabled = TRUE AND U.IsVirtual = FALSE AND ((SELECT COUNT(*) FROM Organization_BelongToDepartment B WHERE B.UserNo = U.UserNo) = 0)
		AND (U.UserID ILIKE '%' || SearchText || '%' OR U.Name ILIKE '%' || SearchText || '%' OR U.Name_EN ILIKE '%' || SearchText || '%' OR U.MailAddress ILIKE '%' || SearchText || '%')
	ORDER BY U.Name ASC


	IF (SELECT COUNT(*) FROM Sorting) = 0 BEGIN

		RETURN QUERY
		SELECT COUNT(*) AS cnt
		FROM ListOfUsers

		RETURN QUERY
		SELECT
			sub.UserNo, 
			sub.ModUserNo, 
			sub.ModDate, 
			sub.UserID, 
			sub.Name, 
			sub.Name_EN, 
			sub.MailAddress, 
			sub.CellPhone, 
			sub.CompanyPhone, 
			sub.ExtensionNumber,
			sub.UserPhoto, 
			sub.Photo,
			sub.Enabled, 
			sub.DepartNo, 
			sub.DepartName, 
			sub.DepartName_EN, 
			sub.DepartSortNo, 
			sub.PositionNo, 
			sub.PositionName, 
			sub.PositionName_EN, 
			sub.PositionSortNo,
			sub.DutyNo, 
			sub.DutyName, 
			sub.DutyName_EN, 
			sub.DutySortNo, 
			sub.BirthDate,
			sub.Name_CH,
			sub.Name_JP,
			sub.Name_VN,
			sub.DepartName_CH,
			sub.DepartName_JP,
			sub.DepartName_VN,
			sub.PositionName_CH,
			sub.PositionName_JP,
			sub.PositionName_VN,
			sub.DutyName_CH,
			sub.DutyName_JP,
			sub.DutyName_VN
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY UserNo) AS rowNum, 
				RowIdx,
				UserNo, 
				ModUserNo, 
				ModDate, 
				UserID, 
				Name, 
				Name_EN, 
				MailAddress, 
				CellPhone, 
				CompanyPhone, 
				ExtensionNumber,
				UserPhoto, 
				Photo,
				Enabled, 
				DepartNo, 
				DepartName, 
				DepartName_EN, 
				DepartSortNo, 
				PositionNo, 
				PositionName, 
				PositionName_EN, 
				PositionSortNo,
				DutyNo, 
				DutyName, 
				DutyName_EN, 
				DutySortNo, 
				BirthDate,
				Name_CH,
				Name_JP,
				Name_VN,
				DepartName_CH,
				DepartName_JP,
				DepartName_VN,
				PositionName_CH,
				PositionName_JP,
				PositionName_VN,
				DutyName_CH,
				DutyName_JP,
				DutyName_VN		
			FROM ListOfUsers
		) AS sub
		WHERE
			sub.rowNum BETWEEN ((CurrentPageIndex - 1) * PagePerCount) + 1 AND PagePerCount * CurrentPageIndex
		ORDER BY 
			RowIdx ASC

	END

	ELSE BEGIN


			RowIdx			INT,
			UserNo			INT,
			ModUserNo		INT,
			ModDate			DATETIME,
			UserID			VARCHAR(100),
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
			L.Enabled, L.DepartNo, L.DepartName, L.DepartName_EN, L.DepartSortNo, L.PositionNo, L.PositionName, L.PositionName_EN, L.PositionSortNo,
			L.DutyNo, L.DutyName, L.DutyName_EN, L.DutySortNo, L.BirthDate
			,L.Name_CH,L.Name_JP,L.Name_VN,L.DepartName_CH,L.DepartName_JP,L.DepartName_VN,L.PositionName_CH,
			L.PositionName_JP,L.PositionName_VN,L.DutyName_CH,L.DutyName_JP	,L.DutyName_VN	
		FROM ListOfUsers AS L 
		LEFT JOIN Sorting AS S ON S.UserNo = L.UserNo

		UPDATE ListOfUsers2 SET RowIdx = (SELECT MAX(RowIdx) FROM ListOfUsers2 A WHERE A.PositionSortNo >= PositionSortNo)
		WHERE RowIdx IS NULL

		RETURN QUERY
		SELECT COUNT(*) AS cnt
		FROM ListOfUsers2

		RETURN QUERY
		SELECT
			sub.UserNo, 
			sub.ModUserNo, 
			sub.ModDate, 
			sub.UserID, 
			sub.Name, 
			sub.Name_EN, 
			sub.MailAddress, 
			sub.CellPhone, 
			sub.CompanyPhone, 
			sub.ExtensionNumber,
			sub.UserPhoto, 
			sub.Photo,
			sub.Enabled, 
			sub.DepartNo, 
			sub.DepartName, 
			sub.DepartName_EN, 
			sub.DepartSortNo, 
			sub.PositionNo, 
			sub.PositionName, 
			sub.PositionName_EN, 
			sub.PositionSortNo,
			sub.DutyNo, 
			sub.DutyName, 
			sub.DutyName_EN, 
			sub.DutySortNo, 
			sub.BirthDate,
			sub.Name_CH,
			sub.Name_JP,
			sub.Name_VN,
			sub.DepartName_CH,
			sub.DepartName_JP,
			sub.DepartName_VN,
			sub.PositionName_CH,
			sub.PositionName_JP,
			sub.PositionName_VN,
			sub.DutyName_CH,
			sub.DutyName_JP,
			sub.DutyName_VN
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY UserNo) AS rowNum,
				RowIdx,
				UserNo, 
				ModUserNo, 
				ModDate, 
				UserID, 
				Name, 
				Name_EN, 
				MailAddress, 
				CellPhone, 
				CompanyPhone, 
				ExtensionNumber,
				UserPhoto, 
				Photo,
				Enabled, 
				DepartNo, 
				DepartName, 
				DepartName_EN, 
				DepartSortNo, 
				PositionNo, 
				PositionName, 
				PositionName_EN, 
				PositionSortNo,
				DutyNo, 
				DutyName, 
				DutyName_EN, 
				DutySortNo, 
				BirthDate,
				Name_CH,
				Name_JP,
				Name_VN,
				DepartName_CH,
				DepartName_JP,
				DepartName_VN,
				PositionName_CH,
				PositionName_JP,
				PositionName_VN,
				DutyName_CH,
				DutyName_JP,
				DutyName_VN	
			FROM 
				ListOfUsers2
		) AS sub
		WHERE
			sub.rowNum BETWEEN ((CurrentPageIndex - 1) * PagePerCount) + 1 AND PagePerCount * CurrentPageIndex
		ORDER BY 
			RowIdx ASC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
