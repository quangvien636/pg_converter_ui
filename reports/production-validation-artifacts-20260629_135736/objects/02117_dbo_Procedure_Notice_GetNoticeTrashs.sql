-- ─── PROCEDURE→FUNCTION: notice_getnoticetrashs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.notice_getnoticetrashs(integer, integer, integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.notice_getnoticetrashs(
    IN p_uno integer,
    IN p_side integer,
    IN p_index integer,
    IN p_sdate character varying,
    IN p_edate character varying,
    IN p_sort character varying,
    IN p_lang character varying,
    IN p_arq character varying DEFAULT ''
) RETURNS void
AS $function$
DECLARE
    query character varying;
    orderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	CREATE TEMP TABLE tam AS SELECT COALESCE((select OptionValue INTO comment FROM NoticeOptions WHERE OptionKey = 'comment'),'Y')
	SELECT /* TOP 1 */ p_userid = Userid FROM Organization_Users WHERE UserNo = notice_getnoticetrashs.p_uno
	select NoticeNo FROM NoticeReference where UserID = p_userid
	group by NoticeNo
	

	IF(p_lang = 'VN') SET QueryUname = 'COALESCE(u.Name_VN,u.Name) AS UserName'  
	IF(p_lang = 'JP') SET QueryUname = 'COALESCE(u.Name_JP,u.Name) AS UserName'  
	IF(p_lang = 'CH') SET QueryUname = 'COALESCE(u.Name_CH,u.Name) AS UserName'  
	IF(p_lang = 'EN') SET QueryUname = 'COALESCE(u.Name_EN,u.Name) AS UserName'  


	IF(p_lang = 'VN') SET QueryUname2 = 'COALESCE(u2.Name_VN,u2.Name) AS DName'  
	IF(p_lang = 'JP') SET QueryUname2 = 'COALESCE(u2.Name_JP,u2.Name) AS DName'  
	IF(p_lang = 'CH') SET QueryUname2 = 'COALESCE(u2.Name_CH,u2.Name) AS DName'  
	IF(p_lang = 'EN') SET QueryUname2 = 'COALESCE(u2.Name_EN,u2.Name) AS DName'  



	OrderBy := ' N.RegDate DESC ';
	IF (p_sort = 'ASC_DIVISION') SET OrderBy = ' ND.Name ASC ' THEN
	ELSIF (p_sort = 'DESC_DIVISION') SET OrderBy = ' ND.Name DESC ' THEN
	ELSIF (p_sort = 'ASC_TITLE') SET OrderBy = ' N.Title ASC ' THEN
	ELSIF (p_sort = 'DESC_TITLE') SET OrderBy = ' N.Title DESC ' THEN
	ELSIF (p_sort = 'ASC_WRITER') SET OrderBy = ' U.Name ASC ' THEN
	ELSIF (p_sort = 'DESC_WRITER') SET OrderBy = ' U.Name DESC ' THEN
	ELSIF (p_sort = 'ASC_REGDATE') SET OrderBy = ' N.RegDate ASC ' THEN
	ELSIF (p_sort = 'DESC_REGDATE') SET OrderBy = ' N.RegDate DESC ' THEN
	ELSIF (p_sort = 'ASC_ATTACH') SET OrderBy = ' N.IsAttach ASC  ' THEN
	ELSIF (p_sort = 'DESC_ATTACH') SET OrderBy = ' N.IsAttach DESC ' THEN
	ELSIF (p_sort = 'ASC_VIEWCNT') SET OrderBy = ' N.CurrentViews ASC ' THEN
	ELSIF (p_sort = 'DESC_VIEWCNT') SET OrderBy = ' N.CurrentViews DESC ' THEN
	ELSIF (p_sort = 'Important') SET OrderBy = 'N.Important DESC,  N.RegDate DESC ' THEN
	ELSIF (p_sort = '') SET OrderBy = 'N.RegDate DESC, N.Important DESC' THEN

	Query := 'SELECT ';
	SET Query +=  'T.TotalCnt'
	SET Query +=  ', T.RowNum '
	SET Query +=  ', T.NoticeNo '
	SET Query +=  ', T.RegUserNo '
	SET Query +=  ', T.RegDate '
	SET Query +=  ', T.DeleteDate as Ddate '
	SET Query +=  ', T.UserName '
	SET Query +=  ', T.DName '
	SET Query +=  ', T.Title '
	SET Query +=  ', T.DivisionNo '
	SET Query +=  ', T.DivisionName '
	SET Query +=  ', T.IsShare '
	SET Query +=  ', T.DivisionNo '
	SET Query +=  ', T.DivisionNo '
	SET Query +=  ', T.Important, T.IsAttach, T.TotalViews '
	SET Query +=  ', T.StartDate, T.EndDate, T.Content,  0 as TotalUserCnt ' --- TotalUserCnt noneed
	SET Query +=  ', T.CurrentViews '  ----CurrentViews in Notice
	SET Query +=  ', T.CurrentViews AS ViewUserCnt '  ---==== CurrentViews
	SET Query +=  ', T.IsSeen '
	IF comment = 'Y' THEN
		SET Query +=  ', (select count(nc.CommentNo) from NoticeComments nc where nc.NoticeNo = T.NoticeNo) AS mesCount '
	ELSE
		SET Query +=  ', 0 AS mesCount '
	SET Query +=  ', public."fn_GetDepartmentName"(T.DepartNo,''' || p_lang || ''') AS ''department'' '
	SET Query +=  ', public."fn_GetDepartmentName"(T.DepartNo,''EN'') AS ''department_en'' '
	SET Query +=  ', public."UF_PositionName"(T.RegUserNo) AS ''position'' '
	SET Query +=  ', public."UF_PositionName_EN"(T.RegUserNo) AS ''position_en'' '
	SET Query +=  ', T.IsPopup '
	SET Query +=  ' FROM ('
	SET Query +=  '	SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY '
	SET Query +=              OrderBy
	SET Query +=  '	     )) AS RowNum, '
	SET Query +=  '	     N.NoticeNo, '
	SET Query +=  '	     N.RegUserNo, '
	SET Query +=  '	     N.RegDate, '
	SET Query +=  '	     N.DeleteDate, '
	SET Query +=  QueryUname || ','
	SET Query +=  QueryUname2 || ','
	SET Query +=  '	     N.Title, '
	SET Query +=  '	     N.DivisionNo, '
	SET Query +=  '	     ND.Name AS DivisionName, '
	SET Query +=  '	     N.IsShare, '
	SET Query +=  '	     N.Important, N.IsAttach, N.TotalViews,  '
	SET Query +=  '	     N.StartDate, N.EndDate, '''' as Content, n.CurrentViews '
	SET Query +=  ' ,N.IsPopup, N.DepartNo '
	SET Query +=  ' , COALESCE(t.NoticeNo, 0) as IsSeen '
	SET Query +=  '	FROM NoticesDelete N '
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query +=  '		INNER JOIN Organization_Users U2 ON U2.UserNo = N.UserNo '
	SET Query +=  '		INNER JOIN NoticeDivisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query +=  '		LEFT JOIN tam  t ON t.NoticeNo = N.NoticeNo '
	SET Query +=  '	WHERE  (N.RegDate BETWEEN ''' || p_sdate || ''' AND ''' || p_edate || ''')'
	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((p_index - 1) * p_side) + 1) + ' AND ' || CONVERT(NVARCHAR(20), p_index * p_side) + 'order by t.RowNum '
	
	--PRINT Query
	PERFORM query();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
