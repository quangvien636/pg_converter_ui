-- ─── FUNCTION: notice_getnoticewgs ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getnoticewgs(integer, character varying, integer, integer, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_getnoticewgs(
    p_uno integer,
    p_isadm character varying,
    p_view integer,
    p_index integer,
    p_sdate character varying,
    p_edate character varying,
    p_divno integer
) RETURNS TABLE(
    noticeno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    departno integer;
    query character varying;
    orderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	RETURN QUERY
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getnoticewgs.p_uno



	SET OrderBy = ' N.RegDate DESC '

	SET Query  =  'SELECT T.* '
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
	IF (p_Divno > 0) BEGIN
		SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), p_Divno) + ' '
	END
	IF p_isAdm = '' BEGIN
	   SET Query +=  '		 AND (NOW() >= N.STARTDATE OR ( N.RegUserNo = ' || CONVERT(text, p_Uno)+'))' 
		SET Query +=  '	   AND (IsShare = FALSE ' 
		SET Query +=  '			 OR ( N.RegUserNo = ' || CONVERT(text, p_Uno)+')' 
		SET Query +=  ' OR (N.NoticeNo IN ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=' || CONVERT(nvarchar(10),p_Uno ) +  ')) OR (N.NoticeNo IN ( SELECT s.NoticeNo FROM NoticeSharers s where s.DepartNo = ' || CONVERT(nvarchar(20), DepartNo) + ' ) )  ) '

	END

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((p_Index - 1) * p_View) + 1) + ' AND ' || CONVERT(NVARCHAR(20), p_Index * p_View) + 'order by t.RowNum '
	
	--PRINT Query
	EXEC SP_EXECUTESQL Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
