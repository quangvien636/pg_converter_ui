-- ─── PROCEDURE→FUNCTION: notice_getnotices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.notice_getnotices(integer, character varying, integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.notice_getnotices(
    IN userno integer,
    IN isadmin character varying,
    IN viewcount integer,
    IN currentpageindex integer,
    IN endview character varying,
    IN treesub character varying,
    IN serchtype integer,
    IN serchtext character varying,
    IN sdate character varying,
    IN edate character varying,
    IN sortcolumn character varying,
    IN divisionno integer,
    IN importantonly boolean,
    IN p_arq character varying DEFAULT ''
) RETURNS void
AS $function$
DECLARE
    tbl table(departno int,parentno int);
    query character varying;
    orderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	CREATE TEMP TABLE tam AS SELECT COALESCE((select OptionValue INTO comment FROM NoticeOptions WHERE OptionKey = 'comment'),'Y')
	SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getnotices.userno
	SELECT /* TOP 1 */ p_userid = Userid FROM Organization_Users WHERE UserNo = notice_getnotices.userno
	select NoticeNo FROM NoticeReference where UserID = p_userid
	group by NoticeNo


	insert into tbl(DepartNo, ParentNo)
	CREATE TEMP TABLE tbl AS SELECT DepartNo, 0 FROM Organization_BelongToDepartment WHERE UserNo = notice_getnotices.userno
	if(TreeSub = 'Y')
	begin
		with name_tree as 
		(
		   select DepartNo, ParentNo
		   from Organization_Departments
		   where DepartNo in ( select DepartNo FROM tbl )
		   union all
		   select C.DepartNo, C.ParentNo
		   from Organization_Departments c
		   join name_tree p on C.DepartNo = P.ParentNo
		   AND C.DepartNo<>C.ParentNo 
		) ;
		insert into tbl(DepartNo, ParentNo)
		select DepartNo, ParentNo
		from name_tree;END;
	
	SELECT distinct DepartNo FROM tbl


	IF(p_lang = 'VN') SET QueryUname = 'COALESCE(u.Name_VN,u.Name) AS UserName'  
	IF(p_lang = 'JP') SET QueryUname = 'COALESCE(u.Name_JP,u.Name) AS UserName'  
	IF(p_lang = 'CH') SET QueryUname = 'COALESCE(u.Name_CH,u.Name) AS UserName'  
	IF(p_lang = 'EN') SET QueryUname = 'COALESCE(u.Name_EN,u.Name) AS UserName'  



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
	ELSIF (SortColumn = 'ASC_VIEWCNT') SET OrderBy = ' N.CurrentViews ASC ' THEN
	ELSIF (SortColumn = 'DESC_VIEWCNT') SET OrderBy = ' N.CurrentViews DESC ' THEN
	ELSIF (SortColumn = 'Important') SET OrderBy = 'N.Important DESC,  N.RegDate DESC ' THEN
	ELSIF (SortColumn = '') SET OrderBy = 'N.RegDate DESC, N.Important DESC' THEN

	Query := 'SELECT;
	T.TotalCnt
	, T.RowNum 
	, T.NoticeNo 
	, T.RegUserNo 
	, T.RegDate 
	, T.UserName 
	, T.Title 
	, T.DivisionNo 
	, T.DivisionName 
	, T.IsShare 
	, T.DivisionNo 
	, T.DivisionNo 
	, T.Important, T.IsAttach, T.TotalViews 
	, T.StartDate, T.EndDate, T.Content,  0 as TotalUserCnt 
	, T.CurrentViews 
	, T.CurrentViews AS ViewUserCnt 
	, T.IsSeen' 
	IF comment = 'Y' THEN
		SET Query +=  ', (select count(nc.CommentNo) from NoticeComments nc where nc.NoticeNo = T.NoticeNo) AS mesCount '
	ELSE
		SET Query +=  ', 0 AS mesCount '
	SET Query +=  ', public."fn_GetDepartmentName"(T.DepartNo,p_lang) AS department
	, public."fn_GetDepartmentName"(T.DepartNo,''EN'') AS department_en
	, public."UF_PositionName"(T.RegUserNo) AS position
	, public."UF_PositionName_EN"(T.RegUserNo) AS position_en
	, T.IsPopup 
	 FROM (
		SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, 
		     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY '
	SET Query +=              OrderBy
	SET Query += 	     ')) AS RowNum, 
		     N.NoticeNo, 
		     N.RegUserNo, 
		     N.RegDate, '
	SET Query +=  QueryUname || ','
	SET Query +=  '	     N.Title, 
		     N.DivisionNo, 
		     ND.Name AS DivisionName, 
		     N.IsShare, 
		     N.Important, N.IsAttach, N.TotalViews,  
		     N.StartDate, N.EndDate, '''' as Content, n.CurrentViews 
	 ,N.IsPopup, N.DepartNo 
	 , COALESCE(t.NoticeNo, COALESCE(n.IsSeen2,0)) as IsSeen 
		FROM Notices  N 
			INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo 
			INNER JOIN NoticeDivisions  ND ON ND.DivisionNo = N.DivisionNo 
			LEFT JOIN tam  t ON t.NoticeNo = N.NoticeNo 
		WHERE (N.RegDate BETWEEN  SDate AND  EDate )'
	IF p_Arq = 'Arq' THEN
		SET Query +=  'AND  N.EndDate <= convert(datetime,convert(varchar, NOW(), 23)) '
	END IF;
	IF SerchText <> '' THEN
		SET Query +=  '		AND (CASE WHEN SerchType = 1 THEN N.Title 
		WHEN SerchType = 2 THEN N.Content 
		WHEN SerchType = 3 THEN U.Name	
		ELSE N.Title 
		END) ILIKE ''%'' || SerchText || ''%'''
	END IF;
	
	IF (EndView = '') BEGIN --20231123 THEN
		if(IsAdmin = '')
			SET Query +=  '		AND ( ((convert(datetime,convert(varchar, NOW(), 23)) BETWEEN N.StartDate AND  N.EndDate)  OR ( N.RegUserNo =  UserNo AND convert(datetime,convert(varchar, NOW(), 23)) < N.StartDate  ) ) )'
	    ELSE
		   SET Query +=  '		AND ( ((convert(datetime,convert(varchar, NOW(), 23)) BETWEEN N.StartDate AND  N.EndDate)  OR ( convert(datetime,convert(varchar, NOW(), 23)) < N.StartDate  ) ) )'
		
	END;
	IF DivisionNo > 0 THEN
		SET Query +=  '		AND  N.DivisionNo =  DivisionNo '
	END IF;

	IF ImportantOnly = 1 THEN
		SET Query +=  '		AND  n.Important = 1 '
	END IF;
	IF IsAdmin = '' THEN
	   SET Query +=  '		 AND (NOW() >= N.STARTDATE OR  N.RegUserNo = UserNo)' 
		SET Query +=  '	   AND (IsShare = FALSE OR  N.RegUserNo = UserNo' 
		SET Query +=  ' OR EXISTS ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=UserNo ) OR EXISTS ( SELECT s.NoticeNo FROM NoticeSharers s where N.NoticeNo = s.NoticeNo and s.DepartNo in(SELECT DepartNo FROM tbl)   )  ) '
	END IF;

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN (CurrentPageIndex - 1) * ViewCount + 1  AND  CurrentPageIndex * ViewCount order by t.RowNum '
	
	RAISE NOTICE '%', Query
	EXECUTE format(Query, UserNo);
 ,IsAdmin ,  
 ViewCount   ,   
 CurrentPageIndex ,   
 EndView   ,  
 TreeSub   ,  
 SerchType   ,   
 SerchText   , 
 SDate   , 
 EDate   , 
 SortColumn , 
 DivisionNo ,   
 ImportantOnly ,
 p_lang  ,
 p_Arq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
