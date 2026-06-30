-- ─── FUNCTION: integrated_getallmultitable ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getallmultitable(character varying, character varying, integer, integer, integer, integer, boolean, integer, integer, character varying, timestamp without time zone, timestamp without time zone, character varying, integer);
CREATE OR REPLACE FUNCTION public.integrated_getallmultitable(
    endview character varying,
    isadmin character varying,
    divisionno integer,
    treeroot integer,
    userno integer,
    boardno integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer,
    languagesign character varying,
    fromdate timestamp without time zone,
    todate timestamp without time zone,
    serchtext character varying,
    serchtype integer
) RETURNS TABLE(
    totalcnt text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    departno integer;
    query character varying;
    query1 character varying;
    query2 character varying;
    query3 character varying;
    sortcolumn character varying;
    orderby character varying;
    checkhq character varying;
    sql character varying;
    count character varying;
    cntall integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */








	select CheckHQ = WorkPlaceType from Organization_Users where UserNo=integrated_getallmultitable.userno



	IF (IsAscending = TRUE) SET OrderBy = ' ASC '
	ELSE SET OrderBy = ' DESC '

if(BoardNo>-1) BEGIN
	SET Query  =  'SELECT T.TotalCnt,T.RowNum,T.Id ,T.Title,T.RegUserNo, T.RegDate, T.PositionName, T.DepartName , T.CatName, T.UserName, T.ReadCount, 0 as TableType'	
	SET Query += ' FROM ('
	
	SET Query += 'SELECT '
	SET Query +=  ' CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '

	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY BC.RegDate '
	SET Query +=   ' ' || OrderBy || ' '
	SET Query +=  '	     )) AS RowNum, '	
	SET Query +=  ' CONVERT(int, BC.ContentNo) as Id, BC.Title,BC.RegUserNo ,BC.RegDate ,
	BC.ModPositionNo as PositionNo, BC.ModPositionName as PositionName,
	BC.ModDepartName as DepartName, B.Name as CatName, U.Name AS UserName,  (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) AS  ReadCount  ' +
		'FROM Board_Contents BC'
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = BC.RegUserNo '
	SET Query +=  '		INNER JOIN Board_Boards B ON B.BoardNo = BC.BoardNo '
		
	SET Query +='	 WHERE 1=1 AND BC.Enabled = TRUE '
	SET Query +=' AND  BC.BoardNo =' || CONVERT(nvarchar(20), BoardNo) + ' '
	
	IF (SerchText <> '') BEGIN
		SET Query +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query +=  '			WHEN 1 THEN BC.Title '
		--SET Query +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		--SET Query +=  '			WHEN 3 THEN U.Name	'
		SET Query +=  '			ELSE BC.Title '
		SET Query +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END
	SET Query += ') T '
	SET Query += ' WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '


SET sql = Query 

	SET Query3  = Query || ' ORDER BY RegDate ' || OrderBy


END
	/*
	 * 게시글 검색 시작
	 */
	 
	

	----------------- Integrated --------------------
	


	SELECT CNTALL = COUNT(*) FROM Organization_Users

	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = integrated_getallmultitable.userno

		 if(TreeRoot>-1) begin
	SET Query1  =  'SELECT T.TotalCnt,T.RowNum,CONVERT(int,T.IntegratedNo) as Id ,T.Title,T.RegUserNo, T.RegDate,  T.PositionName, T.Department as DepartName, T.TreeName as CatName, T.UserName, T.ViewUserCnt as ReadCount'
	SET Query1 += ' , 1 as TableType '
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
	IF (SerchText <> '') BEGIN
		SET Query1 +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query1 +=  '			WHEN 1 THEN N.Title '
		SET Query1 +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		SET Query1 +=  '			WHEN 3 THEN U.Name	'
		SET Query1 +=  '			ELSE N.Title '
		SET Query1 +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END
	
	IF (DivisionNo > 0) BEGIN
		SET Query1 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END

	
	IF (TreeRoot<>0) BEGIN
		SET Query1 +=' AND N.TreeRoot=' || CONVERT(nvarchar(50),TreeRoot)+' '
	END
	IF IsAdmin = '' BEGIN
		SET Query1 +=  '		AND (IsShare = FALSE '
		SET Query1 +=  '			 OR IntegratedNo IN '
		SET Query1 +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
	END

	SET Query1 +=  ') T  '
	SET Query1 +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	
	-- PRINT Query

	-- EXEC SP_EXECUTESQL Query1

	SET sql = Query1 

	SET Query3  = Query1 || ' ORDER BY RegDate ' || OrderBy


	END
	
	---------------------- NoticeSyn --------------------------
	if(DivisionNo>-1) begin
	SET Query2  =  'SELECT T.TotalCnt,T.RowNum,CONVERT(int, T.NoticeNo) as Id ,T.Title,T.RegUserNo, T.RegDate,T.PositionName, T.Department as DepartName, T.DivisionName as CatName, T.UserName, T.ViewUserCnt as ReadCount'
	SET Query2 += ', 2 as TableType  '
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
		
	IF (SerchText <> '') BEGIN
		SET Query2 +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query2 +=  '			WHEN 1 THEN N.Title '
		SET Query2 +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		SET Query2 +=  '			WHEN 3 THEN U.Name	'
		SET Query2 +=  '			ELSE N.Title '
		SET Query2 +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END
	IF (EndView = '') BEGIN
		SET Query2 +=  '		AND (N.RegDate BETWEEN ''01-01-2000 00:00:00'''
		SET Query2 +='AND ''08-03-2028 23:59:59'''
		SET Query2 +='OR(SELECT COUNT(*) FROM NoticeSyn_Comments AS NT WHERE '
		SET Query2 +='NT.NoticeNo=N.NoticeNo AND  NT.RegDate BETWEEN ''01-01-2000 00:00:00'' AND'
		SET Query2 +='''08-03-2028 23:59:59'') > 0)'

	END
	

	IF IsAdmin = '' BEGIN
		
			IF(CheckHQ='HQ') BEGIN	
				
					IF(DivisionNo >0) BEGIN
						SET Query2 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
					END
				END
			ELSE IF(CheckHQ='SITE') BEGIN
				IF(DivisionNo=5) BEGIN
					
						SET Query2 +=  '			 AND ((N.RegUserNo = ' || CONVERT(nvarchar(20), UserNo) + ') OR (N.NoticeNo IN '
						SET Query2 +=  '					(SELECT BS1.NoticeNo FROM NoticeSyn_Sharers BS1 INNER JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(20), UserNo) +  ') DP ON DP.DepartNo = BS1.DepartNo)) '
						--SET Query2 +=  ' OR (OB.DepartNo IN (select DepartNo from public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(20), UserNo) +  ')))'
						--SET Query2 +=' OR (OB.DepartNo IN (select * from public."NoticeSyn_GetChildDepartNo"(' || CONVERT(nvarchar(20), UserNo) +')))'
						SET Query2 += ' )'
						SET Query2 += ' AND  N.DivisionNo = 5 '
				END				
				ELSE BEGIN				
					SET Query2 += ' AND  N.DivisionNo = 1 '
				END
			END
		
	END
	ELSE BEGIN
		IF(DivisionNo>0) BEGIN
		SET Query2 +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
		END
		ELSE BEGIN
			SET Query2 += ' AND  N.DivisionNo = 1 '
		END
	END


	SET Query2 +=  ') T  '
	SET Query2 +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * CountPerPage) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * CountPerPage) + ' '
	
	 SET sql = Query2

	SET Query3  =  Query2 || ' ORDER BY T.Important DESC, T.RegDate DESC ' || OrderBy

	 end


	 EXEC SP_EXECUTESQL Query3
	
	 SET count = ' SELECT count(*) as TotalCnt FROM (' || sql || ') as C'
	 RAISE NOTICE '%', Query3;
	EXEC SP_EXECUTESQL count;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
