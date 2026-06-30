-- ─── FUNCTION: integrated_getlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getlist(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getlist(
    userno integer,
    treeno integer,
    treeitem2 integer,
    treeitem3 integer,
    treeroot integer
) RETURNS TABLE(
    integratedno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    query character varying;
    orderby character varying;
    reorderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT CNTALL = COUNT(*) FROM Organization_Users

	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = integrated_getlist.userno



	SET OrderBy = ' N.RegDate DESC '

	IF (SortColumn = 'ASC_DIVISION') SET OrderBy = ' ND.Name ASC ' 
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

	ELSE IF (SortColumn = 'ASC_TREE2') SET OrderBy = ' N.TreeItem2 ASC  '
	ELSE IF (SortColumn = 'DESC_TREE2') SET OrderBy = ' N.TreeItem2 DESC '
	ELSE IF (SortColumn = 'ASC_TREE3') SET OrderBy = ' N.TreeItem3 ASC '
	ELSE IF (SortColumn = 'DESC_TREE3') SET OrderBy = ' N.TreeItem3 DESC '


	ELSE IF (SortColumn = 'ASC_DEPART') SET OrderBy = '  public."UF_DepartmentName"(N.RegUserNo) ASC '
	ELSE IF (SortColumn = 'DESC_DEPART') SET OrderBy = ' public."UF_DepartmentName"(N.RegUserNo) DESC '
	ELSE IF (SortColumn = 'ASC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) ASC '
	ELSE IF (SortColumn = 'DESC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) DESC '
	ELSE IF (SortColumn = '') SET OrderBy = ' N.Important DESC, N.RegDate DESC  '

	SET Query  =  'SELECT * FROM ('
	SET Query +=  '	SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY '
	SET Query +=              OrderBy
	SET Query +=  '	     )) AS RowNum, '
	SET Query +=  '	     N.IntegratedNo, '
	SET Query +=  '	     N.RegUserNo, '
	SET Query +=  '	     N.RegDate, '
	SET Query +=  '	     U.Name AS UserName, '
	SET Query +=  '	     N.Title, '
	SET Query +=  '	     N.DivisionNo, '
	SET Query +=  '	     '' '' AS DivisionName, '
	SET Query +=  '	     N.IsShare, '
	SET Query +=  '	     N.Important, N.IsAttach, N.TotalViews, N.CurrentViews, N.ModUserNo, N.ModDate, '
	SET Query +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query +=  '	     (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt, '
	SET Query +=  '	     (select count(nc.CommentNo) from Integrated_Comments nc where nc.IntegratedNo = N.IntegratedNo) AS mesCount, '
	SET Query +=  '	     public."UF_DepartmentName"(N.RegUserNo) AS ''department'', '
	SET Query +=  '	     public."UF_DepartmentName_EN"(N.RegUserNo) AS ''department_en'', '
	SET Query +=  '	     public."UF_PositionName"(N.RegUserNo) AS ''position'', '
	SET Query +=  '	     public."UF_PositionName_EN"(N.RegUserNo) AS ''position_en'', '
	SET Query +=  '	     N.TypeNo, N.TreeRoot'
	 SET Query += ', N.TreeNo, N.TreeItem2, N.TreeItem3 '
	SET Query += ', TR.Name as TreeName, N.IsImportant'

	SET Query +=  '	FROM Integrateds N '
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	--SET Query +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
	--SET Query +='  INNER JOIN Organization_BelongToDepartment OB ON OB.UserNo=N.RegUserNo'
	SET Query +=	'		INNER JOIN Integrated_TreeItem TR ON TR.ID = N.TreeRoot '
	SET Query +=  '	WHERE 1 = 1 '
	SET Query +=  '	AND (N.RegDate BETWEEN ''' || SDate || ''' AND ''' || EDate || ''' OR  (SELECT COUNT(*) FROM Integrated_Comments AS NT WHERE NT.IntegratedNo=N.IntegratedNo AND  NT.RegDate BETWEEN ''' || SDate || ''' AND ''' || EDate || ''') > 0)'

	IF (SerchText <> '') BEGIN
		SET Query +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query +=  '			WHEN 1 THEN N.Title '
		SET Query +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		SET Query +=  '			WHEN 3 THEN U.Name	'
		SET Query +=  '			ELSE N.Title '
		SET Query +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END
	
	IF (EndView = '') BEGIN
		SET Query +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
	END
	
	IF (DivisionNo > 0) BEGIN
		SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END

	IF(TypeNo<>0) BEGIN
		SET Query += ' AND N.TypeNo= ' || CONVERT(nvarchar(20),TypeNo) +' '
	END

	IF (ImportantOnly = 1) BEGIN
		SET Query +=  '		AND  n.Important = 1 '
	END

	IF (TreeNo<>0) BEGIN
		SET Query +=' AND N.TreeNo=' || CONVERT(nvarchar(20),TreeNo)+' '
	END

	IF (TreeItem2 <>0) BEGIN
		SET Query +=' AND N.TreeItem2=' || CONVERT(nvarchar(50),TreeItem2)+' '
	END
	IF (TreeItem3<>0) BEGIN
		SET Query +=' AND N.TreeItem3=' || CONVERT(nvarchar(50),TreeItem3)+' '
	END
	IF (TreeRoot<>0) BEGIN
		SET Query +=' AND N.TreeRoot=' || CONVERT(nvarchar(50),TreeRoot)+' '
	END
	IF IsAdmin = '' BEGIN
		SET Query +=  '		AND ((IsShare = FALSE '
		SET Query +=  '			 OR IntegratedNo IN '
		SET Query +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
		--SET Query += ' OR '
		SET Query += ')'
	END

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount) + ' '
	IF (SortColumn = '') BEGIN

	SET  ReOrderby= REPLACE(OrderBy,'N.','')

	SET Query +='  ORDER BY ' || ReOrderby
	END
	-- PRINT Query
	EXEC SP_EXECUTESQL Query
	
END;


--------------------------------/////////////////////////////--------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
