-- ─── PROCEDURE→FUNCTION: integrated_getlistwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.integrated_getlistwidget(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getlistwidget(
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(*) INTO cntall FROM Organization_Users

	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = integrated_getlistwidget.userno



	 OrderBy := ' N.RegDate DESC, N.Important DESC  ';
	Query := 'SELECT * FROM (';
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

	IF EndView = '' THEN
		SET Query +=  '		AND  NOW() BETWEEN N.StartDate AND N.EndDate '
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
		SET Query +=' AND N.TreeRoot =' || CONVERT(nvarchar(50),TreeRoot)+' '
	END IF;
	IF IsAdmin = '' THEN
		SET Query +=  '		AND (IsShare = FALSE '
		SET Query +=  '			 OR IntegratedNo IN '
		SET Query +=  '					(SELECT IntegratedNo FROM Integrated_Sharers WHERE DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' )) '
	END IF;

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount) + ' '
	
	-- PRINT Query
	PERFORM query();
END;


--------------------------------/////////////////////////////--------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
