-- ─── PROCEDURE→FUNCTION: notice_getnoticewgs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.notice_getnoticewgs(integer, character varying, integer, integer, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_getnoticewgs(
    IN p_uno integer,
    IN p_isadm character varying,
    IN p_view integer,
    IN p_index integer,
    IN p_sdate character varying,
    IN p_edate character varying,
    IN p_divno integer
) RETURNS SETOF record
AS $function$
DECLARE
    departno integer;
    query character varying;
    orderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getnoticewgs.p_uno



	OrderBy := ' N.RegDate DESC ';
	Query := 'SELECT T.* ';
	SET Query +=  ', (select count(nc.CommentNo) from NoticeComments nc where nc.NoticeNo = T.NoticeNo) AS mesCount '
	SET Query +=  ' FROM ('
	SET Query +=  '	SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY '
	SET Query +=              OrderBy
	SET Query +=  '	     )) AS RowNum, '
	SET Query +=  '	     N.NoticeNo, '
	SET Query +=  '	     N.RegUserNo, '
	SET Query +=  '	     N.RegDate, '
	SET Query +=  '	     N.Title, '
	SET Query +=  '	     N.DivisionNo, '
	SET Query +=  '	     ND.Name AS DivisionName, '
	SET Query +=  '	     N.IsShare, '
	SET Query +=  '	     N.Important, N.IsAttach, N.TotalViews,  '
	SET Query +=  '	     N.StartDate, N.EndDate, '''' as Content, n.CurrentViews '
	SET Query +=  ' ,N.IsPopup, N.DepartNo '
	SET Query +=  '	FROM Notices N '
	SET Query +=  '		INNER JOIN NoticeDivisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query +=  '	WHERE  (N.RegDate BETWEEN ''' || p_SDate || ''' AND ''' || p_EDate || ''') '
	IF p_Divno > 0 THEN
		SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), p_Divno) + ' '
	END IF;
	IF p_isAdm = '' THEN
	   SET Query +=  '		 AND (NOW() >= N.STARTDATE OR ( N.RegUserNo = ' || CONVERT(text, p_Uno)+'))' 
		SET Query +=  '	   AND (IsShare = FALSE ' 
		SET Query +=  '			 OR ( N.RegUserNo = ' || CONVERT(text, p_Uno)+')' 
		SET Query +=  ' OR (N.NoticeNo IN ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=' || CONVERT(nvarchar(10),p_Uno ) +  ')) OR (N.NoticeNo IN ( SELECT s.NoticeNo FROM NoticeSharers s where s.DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' ) )  ) '

	END IF;

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((p_Index - 1) * p_View) + 1) + ' AND ' || CONVERT(NVARCHAR(20), p_Index * p_View) + 'order by t.RowNum '
	
	--PRINT Query
	PERFORM query();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
