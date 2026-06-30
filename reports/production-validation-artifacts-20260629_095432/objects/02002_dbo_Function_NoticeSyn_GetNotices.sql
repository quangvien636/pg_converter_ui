-- ─── FUNCTION: noticesyn_getnotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getnotices(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getnotices(
    userno integer
) RETURNS TABLE(
    departno text
)
AS $function$
DECLARE
    checkhq character varying;
    cntall integer;
    query character varying;
    orderby character varying;
BEGIN



	SELECT CheckHQ= WorkPlaceType FROM Organization_Users where UserNo = noticesyn_getnotices.userno
	SELECT CNTALL = COUNT(*) FROM Organization_Users



	SET OrderBy = ' N.RegDate DESC '

	IF (SortColumn = 'ASC_DIVISION') SET OrderBy = ' ND.Name ASC ' 
	ELSE IF (SortColumn = '') SET OrderBy = ' N.Important DESC, N.RegDate DESC '
	ELSE IF (SortColumn = 'DESC_DIVISION') SET OrderBy = ' ND.Name DESC '
	ELSE IF (SortColumn = 'ASC_TITLE') SET OrderBy = ' N.Title ASC '
	ELSE IF (SortColumn = 'DESC_TITLE') SET OrderBy = ' N.Title DESC '
	ELSE IF (SortColumn = 'ASC_WRITER') SET OrderBy = ' U.Name ASC '
	ELSE IF (SortColumn = 'DESC_WRITER') SET OrderBy = ' U.Name DESC '
	ELSE IF (SortColumn = 'ASC_REGDATE') SET OrderBy = ' N.RegDate ASC '
	ELSE IF (SortColumn = 'DESC_REGDATE') SET OrderBy = ' N.RegDate DESC '
	ELSE IF (SortColumn = 'ASC_ATTACH') SET OrderBy = ' N.IsAttach ASC  '
	ELSE IF (SortColumn = 'DESC_ATTACH') SET OrderBy = ' N.IsAttach DESC '
	ELSE IF (SortColumn = 'ASC_TYPENO') SET OrderBy = ' N.TypeNo ASC '
	ELSE IF (SortColumn = 'DESC_TYPENO') SET OrderBy = ' N.TypeNo DESC '
	ELSE IF (SortColumn = 'ASC_DEPART') SET OrderBy = '  public."UF_DepartmentName"(N.RegUserNo) ASC '
	ELSE IF (SortColumn = 'DESC_DEPART') SET OrderBy = ' public."UF_DepartmentName"(N.RegUserNo) DESC '
	ELSE IF (SortColumn = 'ASC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."NoticeSyn_Reference" WHERE NoticeNo = N.NoticeNo) ASC '
	ELSE IF (SortColumn = 'DESC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."NoticeSyn_Reference" WHERE NoticeNo = N.NoticeNo) DESC '
	

	SET Query  =  'SELECT * FROM ('
	SET Query +=  '	SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY '
	SET Query +=              OrderBy
	SET Query +=  '	     )) AS RowNum, '
	SET Query +=  '	     N.NoticeNo, '
	SET Query +=  '	     N.RegUserNo, '
	SET Query +=  '	     N.RegDate, '
	SET Query +=  '	     U.Name AS UserName, '
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	SET Query +=  '	     N.Title + (case when R.noticeno IS NULL  then ''<font color=red><blink><b> ⓝ</b></blink></font>'' else '''' end ) as title, '
	SET Query +=  '	     N.Title + (case when (R.noticeno IS NULL AND RR.IntegratedNo IS NULL)  then ''<font color=red><blink><b> ⓝ</b></blink></font>'' else '''' end ) as title, '
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------
	SET Query +=  '	     N.DivisionNo, '
	SET Query +=  '	     ND.Name AS DivisionName, '
	SET Query +=  '	     N.IsShare, '
	SET Query +=  '	     N.Important, N.IsAttach, N.TotalViews, N.CurrentViews,  '
	SET Query +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query +=  '	     CASE WHEN N.IntegratedNo > 0 THEN (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo)  ELSE (SELECT COUNT(*) AS CNT FROM public."NoticeSyn_Reference" WHERE NoticeNo = N.NoticeNo) END AS ViewUserCnt, '
	SET Query +=  '	     (select count(nc.CommentNo) from NoticeSyn_Comments nc where nc.NoticeNo = N.NoticeNo) AS mesCount, '
	SET Query +=  '	     public."UF_DepartmentName"(N.RegUserNo) AS ''department'', '
	SET Query +=  '	     public."UF_DepartmentName_EN"(N.RegUserNo) AS ''department_en'', '
	SET Query +=  '	     public."UF_PositionName"(N.RegUserNo) AS ''position'', '
	SET Query +=  '	     public."UF_PositionName_EN"(N.RegUserNo) AS ''position_en'', '
	SET Query +=  '	     N.TypeNo, N.IntegratedNo'
	SET Query +=	', TP.Name as TypeName, N.TreeRoot, N.TreeNo, N.TreeItem2, N.TreeItem3 ,N.IsImportant'
	SET Query +=  '	FROM NoticesSyn N '
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query +=  ' INNER JOIN Organization_BelongToDepartment OB ON OB.UserNo=N.RegUserNo'
	SET Query +=  '		INNER JOIN NoticeSyn_Type TP ON TP.TypeNo = N.TypeNo LEFT OUTER JOIN ( SELECT X.noticeno FROM NoticeSyn_Reference X JOIN Organization_Users Y ON x.UserID = y.UserID WHERE y.userno=' || CONVERT(nvarchar(20), UserNo) + ') R ON R.noticeno=n.noticeno'
	SET Query +=  '																							  LEFT OUTER JOIN ( SELECT IR.IntegratedNo FROM Integrated_Reference IR JOIN Organization_Users OU ON IR.UserID = OU.UserID WHERE OU.userno=' || CONVERT(nvarchar(20), UserNo) + ') RR ON RR.IntegratedNo=n.IntegratedNo	'
	SET Query +=  '	WHERE 1 = 1 '
	SET Query +=  '	AND (N.RegDate BETWEEN ''' || SDate || ''' AND ''' || EDate || ''' )'

	IF (SerchText <> '') BEGIN
		SET Query +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query +=  '			WHEN 1 THEN N.Title '
		SET Query +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		SET Query +=  '			WHEN 3 THEN U.Name	'
		SET Query +=  '			WHEN 4 THEN TP.Name	'
		SET Query +=  '			ELSE N.Title '
		SET Query +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END
	
	IF (EndView = '') BEGIN
		SET Query +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
	END
	

	IF(TypeNo<>0) BEGIN
		SET Query += ' AND N.TypeNo= ' || CONVERT(nvarchar(20),TypeNo) +' '
	END

	IF (ImportantOnly = 1) BEGIN
		SET Query +=  '		AND  n.Important = 1 '
	END
	
	IF IsAdmin = '' BEGIN
		
			IF(CheckHQ='HQ') BEGIN	
					IF(DivisionNo >0) BEGIN
						SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
					END
				END
			ELSE IF(CheckHQ='SITE') BEGIN
				IF(DivisionNo=5) BEGIN
						SET Query +=  '			 AND ((N.RegUserNo = ' || CONVERT(nvarchar(20), UserNo) + ') OR (N.NoticeNo IN '
						SET Query +=  '					(SELECT BS1.NoticeNo FROM NoticeSyn_Sharers BS1 INNER JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(20), UserNo) +  ') DP ON DP.DepartNo = BS1.DepartNo)) '
						SET Query +=  ' OR (OB.DepartNo IN (select DepartNo from public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(20), UserNo) +  ')))'
						SET Query += ' )'
						SET Query += ' AND  N.DivisionNo = 5 '
				END
				ELSE IF(DivisionNo =1) BEGIN
						SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
					END
				ELSE BEGIN
					SET Query += ' AND  N.DivisionNo = 1 '
				END
			END
		
	END
	ELSE BEGIN
		IF(DivisionNo>0) BEGIN
		SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
		END
		ELSE BEGIN
			SET Query += ' AND  N.DivisionNo = 1 '
		END
	END

	SET Query +=  ') N  '
	SET Query +=  'WHERE N.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount) + ' '
			SET Query+=' order by N.RowNum' 
	RAISE NOTICE '%', Query
	EXEC SP_EXECUTESQL Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
