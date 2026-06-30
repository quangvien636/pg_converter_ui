-- ─── FUNCTION: integrated_getlistwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getlistwidget(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getlistwidget(
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT CNTALL = COUNT(*) FROM Organization_Users

	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = integrated_getlistwidget.userno



	 SET OrderBy = ' N.RegDate DESC, N.Important DESC  '

	SET Query  =  'SELECT * FROM ('
	SET Query +=  '	SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY '
	SET Query +=              OrderBy
	SET Query +=  '	     )) AS RowNum, '
	SET Query +=  '	     N.IntegratedNo, '	
	SET Query +=  '	     N.RegDate, '
	SET Query +=  '	     U.Name AS UserName, '
	SET Query +=  '	     N.Title, '
	
	SET Query +=  '	     N.Important, N.TotalViews, N.CurrentViews,  '
	SET Query +=  '	     N.StartDate, N.EndDate, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query +=  '	     (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt, '
	SET Query +=  '	     (select count(nc.CommentNo) from Integrated_Comments nc where nc.IntegratedNo = N.IntegratedNo) AS mesCount, '	
	 SET Query += ' N.TreeNo'
	SET Query += ', TR.Name as TreeName '

	SET Query +=  '	FROM Integrateds N '
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query +=  '		INNER JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query +=	'		INNER JOIN Integrated_TreeItem TR ON TR.ID = N.TreeRoot '
	SET Query +=  '	WHERE 1 = 1 '
	SET Query +=  '	AND (N.RegDate BETWEEN ''' || SDate || ''' AND ''' || EDate || ''' OR  (SELECT COUNT(*) FROM Integrated_Comments AS NT WHERE NT.IntegratedNo=N.IntegratedNo AND  NT.RegDate BETWEEN ''' || SDate || ''' AND ''' || EDate || ''') > 0)'

	IF (EndView = '') BEGIN
		SET Query +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
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
		SET Query +=' AND N.TreeRoot =' || CONVERT(nvarchar(50),TreeRoot)+' '
	END
	IF IsAdmin = '' BEGIN
		SET Query +=  '		AND (IsShare = FALSE '
		SET Query +=  '			 OR IntegratedNo IN '
		SET Query +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
	END

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount) + ' '
	
	-- PRINT Query
	EXEC SP_EXECUTESQL Query
	
END;


--------------------------------/////////////////////////////--------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
