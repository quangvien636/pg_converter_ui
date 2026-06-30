-- ─── PROCEDURE→FUNCTION: integrated_getlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.integrated_getlist(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getlist(
    IN userno integer,
    IN treeno integer,
    IN treeitem2 integer,
    IN treeitem3 integer,
    IN treeroot integer
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    orderby character varying;
    reorderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(*) INTO cntall FROM Organization_Users

	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = integrated_getlist.userno



	OrderBy := ' N.RegDate DESC ';
	IF (SortColumn = 'ASC_DIVISION') SET OrderBy = ' ND.Name ASC ' THEN
	ELSIF (SortColumn = 'DESC_DIVISION') SET OrderBy = ' ND.Name DESC ' THEN
	ELSIF (SortColumn = 'ASC_TITLE') SET OrderBy = ' N.Title ASC ' THEN
	ELSIF (SortColumn = 'DESC_TITLE') SET OrderBy = ' N.Title DESC ' THEN
	ELSIF (SortColumn = 'ASC_WRITER') SET OrderBy = ' U.Name ASC ' THEN
	ELSIF (SortColumn = 'DESC_WRITER') SET OrderBy = ' U.Name DESC ' THEN
	ELSIF (SortColumn = 'ASC_REGDATE') SET OrderBy = ' N.RegDate ASC ' THEN
	ELSIF (SortColumn = 'DESC_REGDATE') SET OrderBy = ' N.RegDate DESC ' THEN
	ELSIF (SortColumn = 'ASC_ATTACH') SET OrderBy = ' N.IsAttach ASC  ' THEN
	ELSIF (SortColumn = 'DESC_ATTACH') SET OrderBy = ' N.IsAttach DESC ' THEN
	ELSIF (SortColumn = 'ASC_TYPENO') SET OrderBy = ' N.TypeNo ASC ' THEN
	ELSIF (SortColumn = 'DESC_TYPENO') SET OrderBy = ' N.TypeNo DESC ' THEN

	ELSIF (SortColumn = 'ASC_TREE2') SET OrderBy = ' N.TreeItem2 ASC  ' THEN
	ELSIF (SortColumn = 'DESC_TREE2') SET OrderBy = ' N.TreeItem2 DESC ' THEN
	ELSIF (SortColumn = 'ASC_TREE3') SET OrderBy = ' N.TreeItem3 ASC ' THEN
	ELSIF (SortColumn = 'DESC_TREE3') SET OrderBy = ' N.TreeItem3 DESC ' THEN


	ELSIF (SortColumn = 'ASC_DEPART') SET OrderBy = '  public."UF_DepartmentName"(N.RegUserNo) ASC ' THEN
	ELSIF (SortColumn = 'DESC_DEPART') SET OrderBy = ' public."UF_DepartmentName"(N.RegUserNo) DESC ' THEN
	ELSIF (SortColumn = 'ASC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) ASC ' THEN
	ELSIF (SortColumn = 'DESC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."Integrated_Reference" WHERE IntegratedNo = N.IntegratedNo) DESC ' THEN
	ELSIF (SortColumn = '') SET OrderBy = ' N.Important DESC, N.RegDate DESC  ' THEN

	Query := 'SELECT * FROM (';
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

	IF SerchText <> '' THEN
		SET Query +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query +=  '			WHEN 1 THEN N.Title '
		SET Query +=  '			WHEN 2 THEN public."UF_DepartmentName"(N.RegUserNo) '
		SET Query +=  '			WHEN 3 THEN U.Name	'
		SET Query +=  '			ELSE N.Title '
		SET Query +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END IF;
	
	IF EndView = '' THEN
		SET Query +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
	END IF;
	
	IF DivisionNo > 0 THEN
		SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END IF;

	IF(TypeNo<>0) BEGIN
		SET Query += ' AND N.TypeNo= ' || CONVERT(nvarchar(20),TypeNo) +' '
	END;

	IF ImportantOnly = 1 THEN
		SET Query +=  '		AND  n.Important = 1 '
	END IF;

	IF TreeNo<>0 THEN
		SET Query +=' AND N.TreeNo=' || CONVERT(nvarchar(20),TreeNo)+' '
	END IF;

	IF TreeItem2 <>0 THEN
		SET Query +=' AND N.TreeItem2=' || CONVERT(nvarchar(50),TreeItem2)+' '
	END IF;
	IF TreeItem3<>0 THEN
		SET Query +=' AND N.TreeItem3=' || CONVERT(nvarchar(50),TreeItem3)+' '
	END IF;
	IF TreeRoot<>0 THEN
		SET Query +=' AND N.TreeRoot=' || CONVERT(nvarchar(50),TreeRoot)+' '
	END IF;
	IF IsAdmin = '' THEN
		SET Query +=  '		AND ((IsShare = FALSE '
		SET Query +=  '			 OR IntegratedNo IN '
		SET Query +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
		--SET Query += ' OR '
		SET Query += ')'
	END IF;

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount) + ' '
	IF SortColumn = '' THEN

	ReOrderby := REPLACE(OrderBy,'N.','');
	SET Query +='  ORDER BY ' || ReOrderby
	END IF;
	-- PRINT Query
	PERFORM query();
END;


--------------------------------/////////////////////////////--------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
