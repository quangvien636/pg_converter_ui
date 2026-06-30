-- ─── PROCEDURE→FUNCTION: notice_checkview ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_checkview(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_checkview(
    IN p_sub character varying,
    IN p_no integer,
    IN p_uno integer
) RETURNS void
AS $function$
DECLARE
    tbl table(departno int,parentno int);
BEGIN



	insert into tbl(DepartNo, ParentNo)
	CREATE TEMP TABLE tbl AS SELECT DepartNo, 0 FROM Organization_BelongToDepartment WHERE UserNo = notice_checkview.p_uno
	if(p_sub = 'Y')
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
	
	SELECT N.NoticeNo, N.RegUserNo

	FROM Notices  N

	WHERE N.NoticeNo = notice_checkview.p_no
		AND (IsShare = FALSE OR  N.RegUserNo = notice_checkview.p_uno 
		 OR EXISTS ( SELECT nss.NoticeNo FROM NoticeSharers nss where nss.NoticeNo=N.NoticeNo and nss.userno=notice_checkview.p_uno ) 
		 OR EXISTS ( SELECT s.NoticeNo FROM NoticeSharers s where N.NoticeNo = s.NoticeNo and s.DepartNo in(SELECT DepartNo FROM tbl)));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
