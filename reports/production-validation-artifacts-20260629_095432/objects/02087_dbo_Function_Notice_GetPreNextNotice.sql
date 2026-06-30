-- ─── FUNCTION: notice_getprenextnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getprenextnotice(integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.notice_getprenextnotice(
    noticeno integer,
    userno integer,
    divisionno integer,
    isadmin boolean
) RETURNS TABLE(
    flag text,
    col2 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    tbl table(departno int,parentno int);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

        --20220927 changed RegDate from Date to DateTime




		RETURN QUERY
		SELECT /* TOP 1 */ DepartNo = DepartNo FROM Organization_BelongToDepartment WHERE UserNo = notice_getprenextnotice.userno
		SELECT noticeView =EndNoticeView,TreeSub = NoticeTreeSub  FROM NoticeSetup


	insert into tbl(DepartNo, ParentNo)
	RETURN QUERY
	select  DepartNo, 0 FROM Organization_BelongToDepartment WHERE UserNo = notice_getprenextnotice.userno
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
		RETURN QUERY
		select DepartNo, ParentNo
		from name_tree;end

	--Is Admin
	IF IsAdmin = TRUE BEGIN ;
		INSERT INTO tab
		RETURN QUERY
		SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY  N.RegDate DESC, N.Important DESC)) AS RowNum,N.NoticeNo ,U.Name,N.Title,N.RegDate
		FROM Notices N  
		INNER JOIN NoticeDivisions ND ON N.DivisionNo=ND.DivisionNo
		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo  
		WHERE ( ND.DivisionNo = notice_getprenextnotice.divisionno OR DivisionNo=0) 
			AND (noticeView='Y' OR NOW() BETWEEN N.StartDate AND  N.EndDate)
	  END 
	  ELSE 
	  BEGIN
	  --Not admin;
		INSERT INTO tab
		RETURN QUERY
		SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY N.RegDate DESC, N.Important DESC)) AS RowNum,N.NoticeNo ,U.Name,N.Title,N.RegDate
		FROM Notices N  
		INNER JOIN NoticeDivisions ND ON N.DivisionNo=ND.DivisionNo 
		INNER JOIN Organization_Users U ON U.UserNo = N.RegUserNo 
		WHERE ( ND.DivisionNo = notice_getprenextnotice.divisionno OR DivisionNo=0) 
		AND (NOW() >= N.STARTDATE OR N.RegUserNo=notice_getprenextnotice.userno)
		AND ( N.IsShare = FALSE  OR N.RegUserNo=notice_getprenextnotice.userno )
		OR EXISTS ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=notice_getprenextnotice.userno)
		OR EXISTS ( SELECT s.NoticeNo FROM NoticeSharers s where N.NoticeNo = s.NoticeNo and s.DepartNo in(SELECT distinct DepartNo FROM tbl)   )  
	  END
	    --select * from tab
		--select currentValue
		select currentValue=RowNum from tab WHERE No=notice_getprenextnotice.noticeno
		--select * from tab;
		INSERT INTO tab1
		RETURN QUERY
		select /* TOP 1 */  1 as Flag,* from tab where RowNum<currentValue Order by RowNum DESC;
		INSERT INTO tab1
		RETURN QUERY
		select /* TOP 1 */ 2 as Flag,* from tab where RowNum>currentValue Order by RowNum ASC
		RETURN QUERY
		select * from tab1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
