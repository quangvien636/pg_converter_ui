-- ─── PROCEDURE→FUNCTION: noticesyn_getcountdepartments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_getcountdepartments();
CREATE OR REPLACE FUNCTION public.noticesyn_getcountdepartments(
) RETURNS void
AS $function$
DECLARE
    tabletemp table(
rownum int identity,
departno int
);
    tableview table (
 rownum int identity,
 userid varchar(100);
    departno integer;
    counttotal integer;
    useriduser character varying;
    useridview character varying;
    count integer;
BEGIN



insert into tableTemp

select DepartNo
 from Organization_Departments where Enabled = TRUE 

 ---------------------
 -- get list view

 )


 insert into tableView
 SELECT UserID FROM public."NoticeSyn_Reference" 
 WHERE NoticeNo = NoticeNo 

 ---------------------------


 
-- --)





 RowIndex := 1;
 MaxIndex := (select count(RowNum) from tableTemp);
 CountTotal := 0;



			
			MaxIndexView := (select count(RowNum) from tableView);
 while(RowIndex<=MaxIndex) begin
	
	SELECT DepartNo INTO departno from tableTemp where RowNum=RowIndex

	IF OBJECT_ID('tempdb.tableUsers') IS NOT NULL THEN
	DROP TABLE tableUsers 
		CREATE TABLE tableUsers(
		RowNum int identity,
		UserId varchar(100)
		)
	


	insert into tableUsers
	select u.UserID from Organization_BelongToDepartment b inner join Organization_Users u on b.UserNo=u.Userno 
	where b.departno=DepartNo and u.Enabled = TRUE
			 
			RowIndexUser := 1;
			MaxIndexUser := (select count(*) from tableUsers);
			UserIdUser := '';
			Count := 0;
			while(RowIndexUser <= MaxIndexUser) begin
				SELECT UserId INTO useriduser from tableUsers where RowNum=RowIndexUser		
				
				UserIdView := '';
				RowIndexView := 1;
				if(Count>0) begin break end
				WHILE RowIndexView<=MaxIndexView LOOP
					SELECT UserId INTO useridview from tableView where RowNum=RowIndexView
									
						if(UserIdUser=UserIdView) begin
							CountTotal := CountTotal+1;
							Count := Count+1;
							EXIT;
						END LOOP;
					
					RowIndexView := RowIndexView+1;
				END;
			RowIndexUser := RowIndexUser+1;
		 END;
	RowIndex := RowIndex+1;
 END;

 select MaxIndex AS Total,CountTotal as CountView;

 -- exec NoticeSyn_GetCountDepartments 251575
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
