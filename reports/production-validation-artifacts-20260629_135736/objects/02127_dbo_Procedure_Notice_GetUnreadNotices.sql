-- ─── PROCEDURE→FUNCTION: notice_getunreadnotices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.notice_getunreadnotices(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_getunreadnotices(
    IN p_uno integer,
    IN p_isadmin character varying,
    IN p_viewcount integer,
    IN p_currentpageindex integer
) RETURNS void
AS $function$
DECLARE
    query character varying;
    orderby character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	CREATE TEMP TABLE tam AS SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getunreadnotices.p_uno
	SELECT /* TOP 1 */ p_userid = Userid FROM Organization_Users WHERE UserNo = notice_getunreadnotices.p_uno
	select NoticeNo FROM NoticeReference where UserID = p_userid
	group by NoticeNo

	with name_tree as 
	(
		CREATE TEMP TABLE tbl AS SELECT DepartNo, ParentNo
		from Organization_Departments
		where DepartNo in ( select DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getunreadnotices.p_uno )
		union all
		select C.DepartNo, C.ParentNo
		from Organization_Departments c
		join name_tree p on C.DepartNo = P.ParentNo
		AND C.DepartNo<>C.ParentNo 
	) 
	select * FROM name_tree;OrderBy := ' N.RegDate DESC ';
	Query := 'SELECT ';
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
	SET Query +=  ', T.Important, T.IsAttach, T.TotalViews '
	SET Query +=  ', T.StartDate, T.EndDate, T.Content,  0 as TotalUserCnt ' --- TotalUserCnt noneed
	SET Query +=  ', T.CurrentViews '  ----CurrentViews in Notice
	SET Query +=  ', T.CurrentViews AS ViewUserCnt '  ---==== CurrentViews
	SET Query +=  ', T.IsSeen '
	SET Query +=  ', 0 AS mesCount '
	SET Query +=  ', public."fn_GetDepartmentName"(T.DepartNo,''' || p_lang || ''') AS ''department'' '
	SET Query +=  ', public."fn_GetDepartmentName"(T.DepartNo,''EN'') AS ''department_en'' '
	SET Query +=  ', public."UF_PositionName"(T.RegUserNo) AS ''position'' '
	SET Query +=  ', public."UF_PositionName_EN"(T.RegUserNo) AS ''position_en'' '
	SET Query +=  ', T.IsPopup '
	SET Query +=  ' FROM ('
	SET Query +=  '	SELECT CONVERT(INT,COUNT(*) OVER()) AS TotalCnt, '
	SET Query +=  '	     CONVERT(INT, ROW_NUMBER() OVER (ORDER BY N.RegDate DESC )) AS RowNum, '
	SET Query +=  '	     N.NoticeNo, '
	SET Query +=  '	     N.RegUserNo, '
	SET Query +=  '	     N.RegDate, '
	SET Query +=  ' ''''	     AS UserName, '
	SET Query +=  '	     N.Title, '
	SET Query +=  '	     N.DivisionNo, '
	SET Query +=  '	     ND.Name AS DivisionName, '
	SET Query +=  '	     N.IsShare, '
	SET Query +=  '	     N.Important, N.IsAttach, N.TotalViews,  '
	SET Query +=  '	     N.StartDate, N.EndDate, '''' as Content, n.CurrentViews '
	SET Query +=  ' ,N.IsPopup, N.DepartNo '
	SET Query +=  ' , 1 as IsSeen '
	SET Query +=  '	FROM Notices N '
	SET Query +=  '		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo '
	SET Query +=  '		INNER JOIN NoticeDivisions ND ON ND.DivisionNo = N.DivisionNo '
	SET Query +=  '	WHERE NOT EXISTS(select 1 from tam ta where ta.NoticeNo = n.NoticeNo)  AND  N.EndDate >= NOW()  '

	IF p_IsAdmin = '' THEN
	   SET Query +=  '		 AND (NOW() >= N.STARTDATE OR ( N.RegUserNo = ' || CONVERT(text, p_UNo)+'))' 
		SET Query +=  '	   AND (IsShare = FALSE ' 
		SET Query +=  '			 OR ( N.RegUserNo = ' || CONVERT(text, p_UNo)+')' 
		SET Query +=  ' OR (N.NoticeNo IN ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=' || CONVERT(nvarchar(10),p_UNo ) +  ')) OR (N.NoticeNo IN ( SELECT s.NoticeNo FROM NoticeSharers s where s.DepartNo in (SELECT distinct DepartNo FROM tbl ) ) )  ) '
	END IF;

	SET Query +=  ') T  '
	SET Query +=  'WHERE T.RowNum BETWEEN ' || CONVERT(NVARCHAR(20), ((p_CurrentPageIndex - 1) * p_ViewCount) + 1) + ' AND ' || CONVERT(NVARCHAR(20), p_CurrentPageIndex * p_ViewCount) + 'order by t.RowNum '
	
	--PRINT Query
	PERFORM query();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
