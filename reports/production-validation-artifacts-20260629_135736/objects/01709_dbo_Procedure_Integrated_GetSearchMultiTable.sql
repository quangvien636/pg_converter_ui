-- ─── PROCEDURE→FUNCTION: integrated_getsearchmultitable ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.integrated_getsearchmultitable(character varying, character varying, integer, integer, integer, integer, boolean, integer, integer, character varying, timestamp without time zone, timestamp without time zone, character varying, integer);
CREATE OR REPLACE FUNCTION public.integrated_getsearchmultitable(
    IN endview character varying,
    IN isadmin character varying,
    IN divisionno integer,
    IN treeroot integer,
    IN userno integer,
    IN boardno integer,
    IN isascending boolean,
    IN countperpage integer,
    IN currentpageindex integer,
    IN languagesign character varying,
    IN fromdate timestamp without time zone,
    IN todate timestamp without time zone,
    IN serchtext character varying,
    IN serchtype integer
) RETURNS SETOF record
AS $function$
DECLARE
    departno integer;
    query character varying;
    query1 character varying;
    query2 character varying;
    query3 character varying;
    querypage character varying;
    orderby character varying;
    cntall integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */







	,
	RegUserNo int,
	RegDate Datetime,
	PositionName nvarchar(200),
	DepartName nvarchar(200),
	CatName nvarchar(200),
	UserName nvarchar(200),
	ReadCount int,
	TableType int
	)


	SELECT COUNT(*) INTO cntall FROM Organization_Users

	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = integrated_getsearchmultitable.userno

	IF (IsAscending = TRUE) SET OrderBy = ' ASC ' THEN
	ELSE SET OrderBy = ' DESC '

	IF(SerchType=0) BEGIN	
	
	Query := 'SELECT T.Id ,T.BoardNo as CatNo, T.Title,T.RegUserNo, T.RegDate, T.PositionName, T.DepartName , T.CatName, T.UserName, T.ReadCount, 3 as TableType';
	SET Query += ' FROM ('
	
	SET Query += 'SELECT '
	SET Query +=  ' CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '

	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY BC.RegDate '
	SET Query +=   ' ' || OrderBy || ' '
	SET Query +=  '	     )) AS RowNum, '	
	SET Query +=  ' BC.ContentNo as Id,BC.BoardNo, BC.Title,BC.RegUserNo ,BC.RegDate ,
	BC.ModPositionNo as PositionNo, BC.ModPositionName as PositionName,
	BC.ModDepartName as DepartName, B.Name as CatName, U.Name AS UserName,  (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) AS  ReadCount  ' +
		'FROM Board_Contents BC'
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = BC.RegUserNo '
	SET Query +=  '		INNER JOIN Board_Boards B ON B.BoardNo = BC.BoardNo '
		
	SET Query +='	 WHERE 1=1 AND BC.Enabled = TRUE '
	IF(BoardNo>0) BEGIN
	 SET Query +=' AND  BC.BoardNo =' || CONVERT(nvarchar(20), BoardNo) + ' '
	END;

	IF SerchText <> '' THEN
		SET Query +=  ' AND BC.Title ILIKE ''%' || SerchText || '%'' '
	END IF;

	
	--SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(30), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(30), ToDate) + '''  ' 

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(30), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(30), ToDate) + ''' ) > 0 ) ' 

	

	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DepartNo = (SELECT /* TOP 1 */ DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
	--END	
	SET Query += ') T '
	--SET Query += ' WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' +
	--	CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	/*
	 * 게시글 검색 시작
	 */
	 
	INSERT INTO tab  EXEC SP_EXECUTESQL Query
	
	----------------- Integrated --------------------
	

	Query1 := 'SELECT  T.IntegratedNo as Id ,T.DivisionNo as CatNo,T.Title,T.RegUserNo, T.RegDate,  T.PositionName, T.Department as DepartName, T.TreeName as CatName, T.UserName, T.ViewUserCnt as ReadCount';
	SET Query1 += ' , 2 as TableType '
	SET Query1 += ' FROM ('
	SET Query1 += 'SELECT '
	SET Query1 +=  '	 CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query1 +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY N.RegDate'
	SET Query1 +=              OrderBy
	SET Query1 +=  '	     )) AS RowNum, '
	SET Query1 +=  '	     N.IntegratedNo, '
	SET Query1 +=  '	     N.RegUserNo, '
	SET Query1 +=  '	     N.RegDate, '
	SET Query1 +=  '	     U.Name AS UserName, '
	SET Query1 +=  '	     N.Title, '
	SET Query1 +=  '	     N.DivisionNo, '
	SET Query1 +=  '	     ND.Name AS DivisionName, '
	-- SET Query1 +=  '	     N.IsShare, '
	SET Query1 +=  '	     N.Important, N.IsAttach, N.TotalViews, N.CurrentViews,  '
	SET Query1 +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query1 +=  '	     (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt, '
	SET Query1 +=  '	     (select count(nc.CommentNo) from Integrated_Comments nc where nc.IntegratedNo = N.IntegratedNo) AS mesCount, '
	SET Query1 +=  '	     public."UF_DepartmentName"(N.RegUserNo) AS ''Department'', '
	SET Query1 +=  '	     public."UF_DepartmentName_EN"(N.RegUserNo) AS ''department_en'', '
	SET Query1 +=  '	     public."UF_PositionName"(N.RegUserNo) AS ''PositionName'', '
	SET Query1 +=  '	     public."UF_PositionName_EN"(N.RegUserNo) AS ''position_en'', '
	SET Query1 +=  '	     N.TypeNo, N.TreeRoot'
	 SET Query1 += ', N.TreeNo, N.TreeItem2, N.TreeItem3 '
	SET Query1 += ', TR.Name as TreeName '

	SET Query1 +=  '	FROM Integrateds N '
	SET Query1 +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query1 +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query1 +=	'		INNER JOIN Integrated_TreeItem TR ON TR.ID = N.TreeRoot '
	SET Query1 +=  '	WHERE 1 = 1 '
	--SET Query1 +=  '	AND (N.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''' OR  (SELECT COUNT(*) FROM Integrated_Comments AS NT WHERE NT.IntegratedNo=N.IntegratedNo AND  NT.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''') > 0)'
	--IF (SerchText <> '') BEGIN
	--	SET Query1 +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
	--	SET Query1 +=  '			WHEN 1 THEN N.Title '
	--	SET Query1 +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
	--	SET Query1 +=  '			WHEN 3 THEN U.Name	'
	--	SET Query1 +=  '			ELSE N.Title '
	--	SET Query1 +=  '			END) ILIKE ''%' || SerchText || '%'' '
	--END
	
	IF SerchText <> '' THEN
		SET Query1 +=  '	AND	 N.Title ILIKE ''%' || SerchText || '%'' '
	END IF;
	IF DivisionNo > 0 THEN
		SET Query1 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END IF;

	
	IF TreeRoot<>0 THEN
		SET Query1 +=' AND N.TreeRoot=' || CONVERT(nvarchar(50),TreeRoot)+' '
	END IF;
	IF IsAdmin = '' THEN
		SET Query1 +=  '		AND (IsShare = FALSE '
		SET Query1 +=  '			 OR IntegratedNo IN '
		SET Query1 +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
	END IF;

	SET Query1 +=  ') T  '
	--SET Query1 +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' +
		--CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	
	-- PRINT Query;
	INSERT INTO tab  EXEC SP_EXECUTESQL Query1
	-- EXEC SP_EXECUTESQL Query1


	---------------------- NoticeSyn --------------------------
	Query2 := 'SELECT  T.NoticeNo as Id ,T.DivisionNo as CatNo,T.Title,T.RegUserNo, T.RegDate,T.PositionName, T.Department as DepartName, T.DivisionName as CatName, T.UserName, T.ViewUserCnt as ReadCount';
	SET Query2 += ', 1 as TableType  '
	SET Query2 += ' FROM ('
	SET Query2 += 'SELECT '
	SET Query2 +=  '	 CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query2 +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY N.RegDate'
	SET Query2 +=              OrderBy
	SET Query2 +=  '	     )) AS RowNum, '
	SET Query2 +=  '	     NoticeNo, '
	SET Query2 +=  '	     N.RegUserNo, '
	SET Query2 +=  '	     N.RegDate, '
	SET Query2 +=  '	     U.Name AS UserName, '
	SET Query2 +=  '	     N.Title, '
	SET Query2 +=  '	     N.DivisionNo, '
	SET Query2 +=  '	     ND.Name AS DivisionName, '
	SET Query2 +=  '	     N.IsShare, '
	SET Query2 +=  '	     N.Important, N.IsAttach, N.TotalViews, N.CurrentViews,  '
	SET Query2 +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query2 +=  '	     (SELECT COUNT(*) AS CNT FROM public."NoticeSyn_Reference" WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt, '
	SET Query2 +=  '	     (select count(nc.CommentNo) from NoticeSyn_Comments nc where nc.NoticeNo = N.NoticeNo) AS mesCount, '
	SET Query2 +=  '	     public."UF_DepartmentName"(N.RegUserNo) AS ''department'', '
	SET Query2 +=  '	     public."UF_DepartmentName_EN"(N.RegUserNo) AS ''department_en'', '
	SET Query2 +=  '	     public."UF_PositionName"(N.RegUserNo) AS ''PositionName'', '
	SET Query2 +=  '	     public."UF_PositionName_EN"(N.RegUserNo) AS ''position_en'', '
	SET Query2 +=  '	     N.TypeNo '
	SET Query2 +=  '	FROM NoticesSyn N '
	SET Query2 +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query2 +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query2 +=  '	WHERE 1 = 1 '
	--SET Query2 +=  '	AND (N.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''' OR  (SELECT COUNT(*) FROM NoticeSyn_Comments AS NT WHERE NT.NoticeNo=N.NoticeNo AND  NT.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''') > 0)'
		
	--IF (SerchText <> '') BEGIN
	--	SET Query2 +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
	--	SET Query2 +=  '			WHEN 1 THEN N.Title '
	--	SET Query2 +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
	--	SET Query2 +=  '			WHEN 3 THEN U.Name	'
	--	SET Query2 +=  '			ELSE N.Title '
	--	SET Query2 +=  '			END) ILIKE ''%' || SerchText || '%'' '
	--END
	IF SerchText <> '' THEN
		SET Query2 +=  '	AND	 N.Title ILIKE ''%' || SerchText || '%'' '
	END IF;
	IF EndView = '' THEN
		SET Query2 +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
	END IF;
	
	IF DivisionNo > 0 THEN
		SET Query2 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END IF;

	

	IF IsAdmin = '' THEN
		SET Query2 +=  '		AND (IsShare = FALSE '
		SET Query2 +=  '			 OR NoticeNo IN '
		SET Query2 +=  '					(SELECT NoticeNo FROM NoticeSyn_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
	END IF;

	SET Query2 +=  ') T  '
	--SET Query2 +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' +
	--	CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	
		INSERT INTO tab  EXEC SP_EXECUTESQL Query2
	END;
	ELSE BEGIN
	
	IF(SerchType=3) BEGIN

	IF (IsAscending = TRUE) SET OrderBy = ' ASC ' THEN
	ELSE SET OrderBy = ' DESC '
	
	Query := 'SELECT T.Id, T.BoardNo as CatNo ,T.Title,T.RegUserNo, T.RegDate, T.PositionName, T.DepartName , T.CatName, T.UserName, T.ReadCount, 3 as TableType';
	SET Query += ' FROM ('
	
	SET Query += 'SELECT '
	SET Query +=  ' CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '

	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY BC.RegDate '
	SET Query +=   ' ' || OrderBy || ' '
	SET Query +=  '	     )) AS RowNum, '	
	SET Query +=  ' BC.ContentNo as Id,BC.BoardNo, BC.Title,BC.RegUserNo ,BC.RegDate ,
	BC.ModPositionNo as PositionNo, BC.ModPositionName as PositionName,
	BC.ModDepartName as DepartName, B.Name as CatName, U.Name AS UserName,  (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) AS  ReadCount  ' +
		'FROM Board_Contents BC'
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = BC.RegUserNo '
	SET Query +=  '		INNER JOIN Board_Boards B ON B.BoardNo = BC.BoardNo '
		
	SET Query +='	 WHERE 1=1 AND BC.Enabled = TRUE '
	IF(BoardNo>0) BEGIN
	 SET Query +=' AND  BC.BoardNo =' || CONVERT(nvarchar(20), BoardNo) + ' '
	END;

	IF SerchText <> '' THEN
		SET Query +=  ' AND BC.Title ILIKE ''%' || SerchText || '%'' '
	END IF;

	
	--SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(30), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(30), ToDate) + '''  ' 

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(30), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(30), ToDate) + ''' ) > 0 ) ' 

	

	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DepartNo = (SELECT /* TOP 1 */ DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
	--END	
	SET Query += ') T '
	
	 
	INSERT INTO tab  EXEC SP_EXECUTESQL Query
	

	END;
	ELSE IF(SerchType=2) BEGIN
		

		Query1 := 'SELECT  T.IntegratedNo as Id ,T.DivisionNo as CatNo, T.Title,T.RegUserNo, T.RegDate,  T.PositionName, T.Department as DepartName, T.TreeName as CatName, T.UserName, T.ViewUserCnt as ReadCount';
		SET Query1 += ' , 2 as TableType '
		SET Query1 += ' FROM ('
		SET Query1 += 'SELECT '
		SET Query1 +=  '	 CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
		SET Query1 +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY N.RegDate'
		SET Query1 +=              OrderBy
		SET Query1 +=  '	     )) AS RowNum, '
		SET Query1 +=  '	     N.IntegratedNo, '
		SET Query1 +=  '	     N.RegUserNo, '
		SET Query1 +=  '	     N.RegDate, '
		SET Query1 +=  '	     U.Name AS UserName, '
		SET Query1 +=  '	     N.Title, '
		SET Query1 +=  '	     N.DivisionNo, '
		SET Query1 +=  '	     ND.Name AS DivisionName, '
		-- SET Query1 +=  '	     N.IsShare, '
		SET Query1 +=  '	     N.Important, N.IsAttach, N.TotalViews, N.CurrentViews,  '
		SET Query1 +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
		SET Query1 +=  '	     (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt, '
		SET Query1 +=  '	     (select count(nc.CommentNo) from Integrated_Comments nc where nc.IntegratedNo = N.IntegratedNo) AS mesCount, '
		SET Query1 +=  '	     public."UF_DepartmentName"(N.RegUserNo) AS ''Department'', '
		SET Query1 +=  '	     public."UF_DepartmentName_EN"(N.RegUserNo) AS ''department_en'', '
		SET Query1 +=  '	     public."UF_PositionName"(N.RegUserNo) AS ''PositionName'', '
		SET Query1 +=  '	     public."UF_PositionName_EN"(N.RegUserNo) AS ''position_en'', '
		SET Query1 +=  '	     N.TypeNo, N.TreeRoot'
		 SET Query1 += ', N.TreeNo, N.TreeItem2, N.TreeItem3 '
		SET Query1 += ', TR.Name as TreeName '

		SET Query1 +=  '	FROM Integrateds N '
		SET Query1 +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
		SET Query1 +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
		SET Query1 +=	'		INNER JOIN Integrated_TreeItem TR ON TR.ID = N.TreeRoot '
		SET Query1 +=  '	WHERE 1 = 1 '
		--SET Query1 +=  '	AND (N.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''' OR  (SELECT COUNT(*) FROM Integrated_Comments AS NT WHERE NT.IntegratedNo=N.IntegratedNo AND  NT.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''') > 0)'
		--IF (SerchText <> '') BEGIN
		--	SET Query1 +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		--	SET Query1 +=  '			WHEN 1 THEN N.Title '
		--	SET Query1 +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		--	SET Query1 +=  '			WHEN 3 THEN U.Name	'
		--	SET Query1 +=  '			ELSE N.Title '
		--	SET Query1 +=  '			END) ILIKE ''%' || SerchText || '%'' '
		--END
	
		IF SerchText <> '' THEN
			SET Query1 +=  '	AND	 N.Title ILIKE ''%' || SerchText || '%'' '
		END IF;
		IF DivisionNo > 0 THEN
			SET Query1 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
		END IF;

	
		IF TreeRoot<>0 THEN
			SET Query1 +=' AND N.TreeRoot=' || CONVERT(nvarchar(50),TreeRoot)+' '
		END IF;
		IF IsAdmin = '' THEN
			SET Query1 +=  '		AND (IsShare = FALSE '
			SET Query1 +=  '			 OR IntegratedNo IN '
			SET Query1 +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
		END IF;

		SET Query1 +=  ') T  '
		--SET Query1 +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' +
			--CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	
		-- PRINT Query;
		INSERT INTO tab  EXEC SP_EXECUTESQL Query1

	END;
	ELSE IF(SerchType=1) BEGIN

	Query2 := 'SELECT  T.NoticeNo as Id ,T.DivisionNo as CatNo,T.Title,T.RegUserNo, T.RegDate,T.PositionName, T.Department as DepartName, T.DivisionName as CatName, T.UserName, T.ViewUserCnt as ReadCount';
	SET Query2 += ', 1 as TableType  '
	SET Query2 += ' FROM ('
	SET Query2 += 'SELECT '
	SET Query2 +=  '	 CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query2 +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY N.RegDate'
	SET Query2 +=              OrderBy
	SET Query2 +=  '	     )) AS RowNum, '
	SET Query2 +=  '	     NoticeNo, '
	SET Query2 +=  '	     N.RegUserNo, '
	SET Query2 +=  '	     N.RegDate, '
	SET Query2 +=  '	     U.Name AS UserName, '
	SET Query2 +=  '	     N.Title, '
	SET Query2 +=  '	     N.DivisionNo, '
	SET Query2 +=  '	     ND.Name AS DivisionName, '
	SET Query2 +=  '	     N.IsShare, '
	SET Query2 +=  '	     N.Important, N.IsAttach, N.TotalViews, N.CurrentViews,  '
	SET Query2 +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query2 +=  '	     (SELECT COUNT(*) AS CNT FROM public."NoticeSyn_Reference" WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt, '
	SET Query2 +=  '	     (select count(nc.CommentNo) from NoticeSyn_Comments nc where nc.NoticeNo = N.NoticeNo) AS mesCount, '
	SET Query2 +=  '	     public."UF_DepartmentName"(N.RegUserNo) AS ''department'', '
	SET Query2 +=  '	     public."UF_DepartmentName_EN"(N.RegUserNo) AS ''department_en'', '
	SET Query2 +=  '	     public."UF_PositionName"(N.RegUserNo) AS ''PositionName'', '
	SET Query2 +=  '	     public."UF_PositionName_EN"(N.RegUserNo) AS ''position_en'', '
	SET Query2 +=  '	     N.TypeNo '
	SET Query2 +=  '	FROM NoticesSyn N '
	SET Query2 +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query2 +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query2 +=  '	WHERE 1 = 1 '
	--SET Query2 +=  '	AND (N.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''' OR  (SELECT COUNT(*) FROM NoticeSyn_Comments AS NT WHERE NT.NoticeNo=N.NoticeNo AND  NT.RegDate BETWEEN ''' || CONVERT(nvarchar(30), FromDate) + ''' AND ''' || CONVERT(nvarchar(30), ToDate) + ''') > 0)'
		
	--IF (SerchText <> '') BEGIN
	--	SET Query2 +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
	--	SET Query2 +=  '			WHEN 1 THEN N.Title '
	--	SET Query2 +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
	--	SET Query2 +=  '			WHEN 3 THEN U.Name	'
	--	SET Query2 +=  '			ELSE N.Title '
	--	SET Query2 +=  '			END) ILIKE ''%' || SerchText || '%'' '
	--END
	IF SerchText <> '' THEN
		SET Query2 +=  '	AND	 N.Title ILIKE ''%' || SerchText || '%'' '
	END IF;
	IF EndView = '' THEN
		SET Query2 +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
	END IF;
	
	IF DivisionNo > 0 THEN
		SET Query2 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END IF;

	

	IF IsAdmin = '' THEN
		SET Query2 +=  '		AND (IsShare = FALSE '
		SET Query2 +=  '			 OR NoticeNo IN '
		SET Query2 +=  '					(SELECT NoticeNo FROM NoticeSyn_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
	END IF;

	SET Query2 +=  ') T  '
	--SET Query2 +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' +
	--	CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	
		INSERT INTO tab  EXEC SP_EXECUTESQL Query2
	END;

END;

	 -- PRINT Query1
	 --exec SP_EXECUTESQL  Query
	 --declare sql text
	 --declare count text


	--SET sql = Query || ' UNION ALL ' || Query1 || ' UNION ALL ' || Query2

	--SET Query3  = Query || ' UNION ALL ' || Query1 || ' UNION ALL ' || Query2 || ' ORDER BY RegDate ' || OrderBy
	
	--PRINT Query3
	 --EXEC SP_EXECUTESQL Query3
	 --
	-- SET count = ' SELECT count(*) as TotalCnt FROM (' || sql || ') as C'
	-- EXEC SP_EXECUTESQL count


	--SET count = 'SELECT COUNT(*) as RowNum FROM (' || sql || ') as C'
	
	----INSERT INTO SearchResult
	--EXEC SP_EXECUTESQL sql

	

	
	--DECLARE TotalItemCount INT
	--DECLARE TotalPageCount INT
	--DECLARE StartRowNum INT
	--DECLARE EndRowNum INT

	--SET TotalItemCount =(SELECT COUNT(*) FROM SearchResult)
	--SET TotalPageCount = TotalItemCount / CountPerPage

	--IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	--IF (TotalPageCount = 0) SET TotalPageCount = 1
	
	--SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	--SET EndRowNum = CurrentPageIndex * CountPerPage

	
	--select TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex

	RETURN QUERY
	select * from (select CONVERT(INT,COUNT(*) OVER()) AS  TotalCnt,
	CONVERT(INT, ROW_NUMBER() OVER (ORDER BY RegDate desc)) AS RowNum,
	* from tab ) T
	where T.RowNum BETWEEN CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1)  
	AND CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) order by T.RegDate desc, T.Id desc

	 RETURN QUERY
	 SELECT count(*) as TotalCnt FROM tab as C;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
