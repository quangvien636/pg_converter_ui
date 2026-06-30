-- ─── FUNCTION: noticesyn_getcountdepartments ───────────────────────────────
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


 
-- declare tableUsers table(
--RowNum int identity,
--UserId varchar(200)
--)





 set RowIndex=1
 set MaxIndex= (select count(RowNum) from tableTemp)


 set CountTotal=0

 





			
			set MaxIndexView=(select count(RowNum) from tableView)


 while(RowIndex<=MaxIndex) begin
	
	select DepartNo=DepartNo from tableTemp where RowNum=RowIndex

	IF OBJECT_ID('tempdb.[#tableUsers]') IS NOT NULL 
	DROP TABLE [#tableUsers] 
		CREATE TABLE [#tableUsers](
		RowNum int identity,
		UserId varchar(100)
		)
	


	insert into #tableUsers
	select u.UserID from Organization_BelongToDepartment b inner join Organization_Users u on b.UserNo=u.Userno 
	where b.departno=DepartNo and u.Enabled = TRUE
			 
			set RowIndexUser=1
			set MaxIndexUser=(select count(*) from #tableUsers)			
			set UserIdUser=''			 
			set Count=0

			while(RowIndexUser <= MaxIndexUser) begin
				select UserIdUser=UserId from #tableUsers where RowNum=RowIndexUser		
				
				set UserIdView=''
				set RowIndexView=1

				if(Count>0) begin break end
				while (RowIndexView<=MaxIndexView) begin							
					select UserIdView=UserId from tableView where RowNum=RowIndexView
									
						if(UserIdUser=UserIdView) begin
							set CountTotal = CountTotal+1
							set Count=Count+1					
							break
						end
					
					set RowIndexView=RowIndexView+1
				end			
			set RowIndexUser = RowIndexUser+1		
		 end
	SET RowIndex=RowIndex+1
 end

 select MaxIndex AS Total,CountTotal as CountView;

 -- exec NoticeSyn_GetCountDepartments 251575
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
