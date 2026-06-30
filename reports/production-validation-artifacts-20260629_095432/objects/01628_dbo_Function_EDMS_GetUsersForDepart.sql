-- ─── FUNCTION: edms_getusersfordepart ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getusersfordepart(character varying, character varying, character varying, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.edms_getusersfordepart(
    orgcd character varying DEFAULT '226',
    chkorgfalg character varying DEFAULT '',
    srcauthority character varying DEFAULT '%',
    username character varying DEFAULT '',
    pagesize integer DEFAULT 10,
    currentpageindex integer DEFAULT 1,
    alsodisabled boolean DEFAULT FALSE
) RETURNS TABLE(
    totalcnt text,
    numrow text,
    userno text,
    moduserno text,
    moddate text,
    userid text,
    usernm text,
    name_en text,
    mailaddress text,
    cellphone text,
    companyphone text,
    userphoto text,
    photo text,
    enabled text,
    departno text,
    orgnm text,
    departname_en text,
    departsortno text,
    positionno text,
    positionname text,
    positionname_en text,
    col22 text,
    dutyno text,
    dutyname text,
    dutyname_en text,
    dutysortno text,
    col27 text,
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
    dutyname_vn text,
    groupadmin text,
    authoritylevel text,
    applyalllist text,
    rowidx text
)
AS $function$
DECLARE
    where character varying;
    query character varying;
    wheregcd character varying;
    sorting table (
		rowidx	int identity,
		userno	int
	);
    tem character varying;
BEGIN








	INSERT INTO Sorting
	RETURN QUERY
	SELECT UserNo FROM Organization_SortingEachDepartment WHERE DepartNo = CONVERT(nvarchar(20),Orgcd)
	

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
		

		Name_CH			NVARCHAR(100),
		Name_JP			NVARCHAR(100),
		Name_VN			NVARCHAR(100),

		DepartName_CH	NVARCHAR(100),
		DepartName_JP	NVARCHAR(100),
		DepartName_VN	NVARCHAR(100),
		
		PositionName_CH	NVARCHAR(100),
		PositionName_JP	NVARCHAR(100),
		PositionName_VN	NVARCHAR(100),

		
		AdminFlag NVARCHAR(100),
		AuthorityLevel NVARCHAR(100),
		ApplyAllList NVARCHAR(100)
	)

	SET Where = ' '
	SET WhereGcd=''
	

	if(SrcAuthority!='%') BEGIN
		if(SrcAuthority!='$$') BEGIN
			SET Where +=' AND  E.AuthorityLevel = ''' || CONVERT(nvarchar(20),SrcAuthority)+''' '
		END
		ELSE BEGIN			
			--SET SrcAuthority='지정등급 없음'
			SET Where +=' AND COALESCE(E.AuthorityLevel,'''') = '''' '
		END
	END

	IF(UserName<>'') BEGIN
		SET Where +=' and E.UserId  ILIKE ''%' || UserName || '%'' '
	END
	if(Orgcd<>'') BEGIN
	
	 --SET WhereGcd =' AND B.DepartNo =' || CONVERT(nvarchar(20),Orgcd) + ' '
	 -- IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(DepartNo, AlsoDisabled))
	 if(ChkOrgfalg = '%') Begin
		SET WhereGcd =' AND B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(' || Orgcd || ', ' || CONVERT(varchar(1), AlsoDisabled) + '))'
	 end
	 else begin
		SET WhereGcd =' AND B.DepartNo =' || CONVERT(nvarchar(20),Orgcd) + ' '
	 end
	END
	
       



	IF (AlsoDisabled = 0) BEGIN	
		
		SET Query = 'SELECT DISTINCT(B.UserNo), U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
			D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
			P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo		
			,U.Name_CH,U.Name_JP,U.Name_VN
			,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
			,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
			
			, E.AdminFlag as GroupAdmin, E.AuthorityLevel, E.ApplyAllList
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo		
		LEFT JOIN edmsUserEnv E ON E.UserId=U.UserID		'
		SET Query +=' WHERE B.IsDefault = TRUE '
		SET Query += WhereGcd
		SET Query += Where
		SET Query +='ORDER BY P.SortNo ASC, U.Name ASC'

	END
	
	ELSE BEGIN	
		
		SET Query = ' SELECT DISTINCT(B.UserNo), U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
			D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
			P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo'			
		SET Query +=',U.Name_CH,U.Name_JP,U.Name_VN
			,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
			,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
			
			, E.AdminFlag as GroupAdmin, E.AuthorityLevel, E.ApplyAllList
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.IsVirtual = FALSE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo			
		LEFT JOIN edmsUserEnv E ON E.UserId=U.UserID		'
		SET Query +=' WHERE B.IsDefault = TRUE '
		SET Query+= WhereGcd
		SET Query += Where
		SET Query +=' ORDER BY P.SortNo ASC, U.Name ASC '
		
	END

	--print Query;
	INSERT INTO ListOfUsers
	EXEC SP_EXECUTESQL Query


	IF (SELECT COUNT(*) FROM Sorting) = 0 BEGIN
	RETURN QUERY
	SELECT * from (
		SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, CONVERT(INT, ROW_NUMBER() OVER (ORDER BY L.RowIdx)) as NumRow , L.UserNo
		, L.ModUserNo, L.ModDate
		 , L.UserID, L.Name as UserNm, L.Name_EN, L.MailAddress, L.CellPhone, L.CompanyPhone, L.UserPhoto, L.Photo,
			L.Enabled, L.DepartNo,
			 L.DepartName as OrgNm
			 , L.DepartName_EN, L.DepartSortNo, L.PositionNo, L.PositionName, L.PositionName_EN, L.PositionSortNo	
			, L.AdminFlag as GroupAdmin, L.AuthorityLevel, L.ApplyAllList, L.RowIdx
		FROM  ListOfUsers  L ) T
		WHERE T.NumRow BETWEEN  CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * PageSize) + 1) AND  CONVERT(NVARCHAR(20), CurrentPageIndex * PageSize)

		--, edmsUserEnv E where E.UserId=L.UserID  
	--ORDER BY L.RowIdx ASC 
	
		--print convert(nvarchar(200),Where) +' '
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
			
			
			
			Name_CH			NVARCHAR(100),
			Name_JP			NVARCHAR(100),
			Name_VN			NVARCHAR(100),

			DepartName_CH	NVARCHAR(100),
			DepartName_JP	NVARCHAR(100),
			DepartName_VN	NVARCHAR(100),
		
			PositionName_CH	NVARCHAR(100),
			PositionName_JP	NVARCHAR(100),
			PositionName_VN	NVARCHAR(100),

			AdminFlag NVARCHAR(100),
			AuthorityLevel NVARCHAR(100),
			ApplyAllList NVARCHAR(100)
		)

		INSERT INTO ListOfUsers2 
		RETURN QUERY
		SELECT S.RowIdx, L.UserNo, L.ModUserNo, L.ModDate, L.UserID, L.Name, L.Name_EN, L.MailAddress, L.CellPhone, L.CompanyPhone, L.UserPhoto, L.Photo,
			L.Enabled, L.DepartNo, L.DepartName, L.DepartName_EN, L.DepartSortNo, L.PositionNo, L.PositionName, L.PositionName_EN, L.PositionSortNo
			
			,L.Name_CH,L.Name_JP,L.Name_VN,L.DepartName_CH,L.DepartName_JP,L.DepartName_VN,L.PositionName_CH,
			L.PositionName_JP,L.PositionName_VN,	L.AdminFlag, L.AuthorityLevel, L.ApplyAllList
		FROM ListOfUsers AS L 		
		LEFT JOIN Sorting AS S ON S.UserNo = L.UserNo

		
		--EXEC SP_EXECUTESQL Query2

		UPDATE ListOfUsers2 SET RowIdx = (SELECT MAX(RowIdx) FROM ListOfUsers2 A WHERE A.PositionSortNo >= PositionSortNo)
		WHERE RowIdx IS NULL

		RETURN QUERY
		SELECT * from (
		SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, CONVERT(INT, ROW_NUMBER() OVER (ORDER BY L.RowIdx)) as NumRow , L.UserNo,
		 L.ModUserNo, L.ModDate, L.UserID, L.Name as UserNm, L.Name_EN, L.MailAddress, L.CellPhone, L.CompanyPhone, L.UserPhoto, L.Photo,
			L.Enabled, L.DepartNo, L.DepartName as OrgNm, L.DepartName_EN, L.DepartSortNo, L.PositionNo, L.PositionName, L.PositionName_EN, L.PositionSortNo
			--,L.DutyNo, L.DutyName, L.DutyName_EN, L.DutySortNo, L.BirthDate
			--,L.Name_CH, L.Name_JP, L.Name_VN, L.DepartName_CH,L.DepartName_JP,L.DepartName_VN, L.PositionName_CH, L.PositionName_JP, L.PositionName_VN, L.DutyName_CH,
			--L.DutyName_JP, L.DutyName_VN
			,L.AdminFlag as GroupAdmin, L.AuthorityLevel, L.ApplyAllList,L.RowIdx
		FROM ListOfUsers2 L ) T
		WHERE T.NumRow BETWEEN  CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * PageSize) + 1) AND  CONVERT(NVARCHAR(20), CurrentPageIndex * PageSize)

		 --ORDER BY RowIdx ASC 
		--EXEC SP_EXECUTESQL Query3
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
