-- ─── FUNCTION: notice_getnotices_search ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getnotices_search(integer);
CREATE OR REPLACE FUNCTION public.notice_getnotices_search(
    userno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    query character varying;
    orderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT CNTALL = COUNT(*) FROM Organization_Users

	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getnotices_search.userno
	select DepartNo into #temdp FROM Organization_BelongToDepartment WHERE UserNo = notice_getnotices_search.userno
	if(TreeSub = 'Y')
	begin
		with name_tree as 
		(
		   select DepartNo, ParentNo
		   from Organization_Departments
		   where DepartNo in ( select DepartNo FROM #temdp )
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.DepartNo = P.ParentNo
		   AND C.DepartNo<>C.ParentNo 
		) 
		-- Here you can INSERT INTO directly to table variable
		--INSERT INTO TABLEVAR
		select * into #tbl
		from name_tree;end
	

	IF(p_lang = 'VN') SET QueryUname = 'COALESCE(u.Name_VN,u.Name) AS UserName'  
	IF(p_lang = 'JP') SET QueryUname = 'COALESCE(u.Name_JP,u.Name) AS UserName'  
	IF(p_lang = 'CH') SET QueryUname = 'COALESCE(u.Name_CH,u.Name) AS UserName'  
	IF(p_lang = 'EN') SET QueryUname = 'COALESCE(u.Name_EN,u.Name) AS UserName'  



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
	ELSE IF (SortColumn = 'ASC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."NoticeReference" WHERE NoticeNo = N.NoticeNo) ASC '
	ELSE IF (SortColumn = 'DESC_VIEWCNT') SET OrderBy = ' (SELECT COUNT(*) AS CNT FROM public."NoticeReference" WHERE NoticeNo = N.NoticeNo) DESC '
	ELSE IF (SortColumn = 'Important') SET OrderBy = 'N.Important DESC,  N.RegDate DESC '
	ELSE IF (SortColumn = '') SET OrderBy = 'N.RegDate DESC, N.Important DESC'

	SET Query  =  'SELECT '
	SET Query +=  'T.TotalCnt'
	SET Query +=  ', T.RowNum '
	SET Query +=  ', T.NoticeNo '
	SET Query +=  ', T.RegUserNo '
	SET Query +=  ', T.RegDate '
	SET Query +=  ', T.UserName '
	SET Query +=  ', T.Title '
	SET Query +=  ', T.DivisionNo '
	SET Query +=  ', T.DivisionName '
	SET Query +=  ', T.IsShare '
	SET Query +=  ', T.DivisionNo '
	SET Query +=  ', T.DivisionNo '
	SET Query +=  ', T.Important, T.IsAttach, T.TotalViews, T.CurrentViews '
	SET Query +=  ', T.StartDate, T.EndDate, T.Content, T.TotalUserCnt '
	SET Query +=  ', public."notice_viewusercnt"(T.NoticeNo,0) AS ViewUserCnt '
	SET Query +=  ', public."notice_viewusercnt"(T.NoticeNo, ' || CONVERT(text, UserNo) +') AS IsSeen '
	SET Query +=  ', (select count(nc.CommentNo) from NoticeComments nc where nc.NoticeNo = T.NoticeNo) AS mesCount '
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
	SET Query +=  '	     NoticeNo, '
	SET Query +=  '	     N.RegUserNo, '
	SET Query +=  '	     N.RegDate, '
	SET Query +=  QueryUname || ','
	SET Query +=  '	     N.Title, '
	SET Query +=  '	     N.DivisionNo, '
	SET Query +=  '	     ND.Name AS DivisionName, '
	SET Query +=  '	     N.IsShare, '
	SET Query +=  '	     N.Important, N.IsAttach, N.TotalViews,  public."Notice_CountReadByUser"(N.NoticeNo, N.IsShare) as CurrentViews,  '
	SET Query +=  '	     N.StartDate, N.EndDate, N.Content, ' || CONVERT(NVARCHAR(20), CNTALL) + ' As TotalUserCnt, '
	SET Query +=  ' N.IsPopup, N.DepartNo'
	SET Query +=  '	FROM Notices N '
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query +=  '		INNER JOIN NoticeDivisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query +=  '	WHERE  (N.RegDate BETWEEN ''' || SDate || ''' AND ''' || EDate || ''')'

	IF (SerchText <> '') BEGIN
		SET Query +=  '		AND (CASE ' || CONVERT(VARCHAR(5), SerchType)
		SET Query +=  '			WHEN 1 THEN N.Title '
		SET Query +=  '			WHEN 2 THEN N.Content '
		SET Query +=  '			WHEN 3 THEN U.Name	'
		SET Query +=  '			ELSE N.Title '
		SET Query +=  '			END) ILIKE ''%' || SerchText || '%'' '
	END
	
	IF (EndView = '') BEGIN
		SET Query +=  '		AND  ((convert(datetime,convert(varchar, NOW(), 23)) BETWEEN N.StartDate AND  N.EndDate) OR N.RegUserNo= ' || CONVERT(text, UserNo) +')'
	END
	
	IF (DivisionNo > 0) BEGIN
		SET Query +=  '		AND  N.DivisionNo = ' || CONVERT(nvarchar(20), DivisionNo) + ' '
	END

	IF (ImportantOnly = 1) BEGIN
		SET Query +=  '		AND  n.Important = 1 '
	END

	IF IsAdmin = '' BEGIN
		SET Query +=  '		AND (IsShare = FALSE '
		SET Query +=  '			 OR ( N.RegUserNo = ' || CONVERT(text, UserNo)+')' 
		IF(TreeSub <> 'Y')
		begin
			SET Query +=  ' OR EXISTS ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=' || CONVERT(nvarchar(10),UserNo ) +  ') OR EXISTS ( SELECT s.NoticeNo FROM NoticeSharers s where N.NoticeNo = s.NoticeNo and s.DepartNo in(SELECT distinct DepartNo FROM #temdp)   )  ) '
		end
		else
		begin
			SET Query +=  'OR EXISTS ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=' || CONVERT(nvarchar(10),UserNo ) +  ') OR EXISTS ( SELECT s.NoticeNo FROM NoticeSharers s where N.NoticeNo = s.NoticeNo and s.DepartNo in (SELECT distinct DepartNo FROM #tbl ) )  ) '
		end
	END

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount) + ' '
	
	--PRINT Query
	EXEC SP_EXECUTESQL Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
