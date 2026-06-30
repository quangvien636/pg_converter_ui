-- ─── PROCEDURE→FUNCTION: notice_getpopups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getpopups(integer);
CREATE OR REPLACE FUNCTION public.notice_getpopups(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    tbl table(departno int,parentno int);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	insert into tbl(DepartNo, ParentNo)
	RETURN QUERY
	select  DepartNo, 0 FROM Organization_BelongToDepartment WHERE UserNo = notice_getpopups.userno
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
		from name_tree;END;

	
	RETURN QUERY
	SELECT N.*,
	public."COMNGetUserName"(N.RegUserNo) As RegUserName
	FROM Notices N 
	WHERE IsPopup = TRUE
	--AND NOW() BETWEEN StartDate AND EndDate
	AND  convert(date, NOW()) >= StartDate AND convert(date, NOW()) <= EndDate
	AND  (convert(date, NOW()) >= PPStartDate AND convert(date, NOW()) <= PPEndDate OR PPStartDate is null)

	AND (IsShare = FALSE OR 
		(IsShare = TRUE AND N.NoticeNo IN (SELECT NoticeNo FROM NoticeSharers  WHERE UserNo = notice_getpopups.userno OR DepartNo IN ((
			SELECT DepartNo FROM tbl
			))))
	)
	AND N.NoticeNo NOT IN (SELECT NoticeNo FROM NoticeReferences WHERE UserNo = notice_getpopups.userno)
	 AND N.RegDate > (SELECT EntranceDate FROM Organization_Users WHERE UserNo = notice_getpopups.userno)
	order by n.NoticeNo desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
