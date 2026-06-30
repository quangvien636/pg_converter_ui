-- ─── PROCEDURE→FUNCTION: noticesyn_getlistuserbydepartmentno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getlistuserbydepartmentno();
CREATE OR REPLACE FUNCTION public.noticesyn_getlistuserbydepartmentno(
) RETURNS SETOF record
AS $function$
DECLARE
    tabledeparment table(
rownum int identity,
departno int

);
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


,
DepartNo int,
DepartName nvarchar(200)
)

insert into tableDeparment
RETURN QUERY
select DepartNo
 from Organization_Departments where Enabled = TRUE


		RowIndex := 1;
		MaxIndex := (SELECT MAX(RowNum) FROM tableDeparment);
WHILE RowIndex <= MaxIndex LOOP

			SELECT  INTO  FROM tableDeparment
			WHERE RowNum = RowIndex
			
			insert into tableUser
			RETURN QUERY
			select u.userNo, u.UserID,b.DepartNo
			,(case when LangCode='EN' then d.Name_EN when LangCode='CH' then d.Name_CH when LangCode='JP' then d.Name_JP when LangCode='VN' then d.Name_VN else d.Name end) as Name 
			from Organization_BelongToDepartment b 
			inner join Organization_Users u on b.UserNo=u.Userno 
			inner join Organization_Departments d on d.DepartNo=b.departno
			where b.departno=DepartNo and u.Enabled = TRUE 


			RowIndex := RowIndex + 1;
		END LOOP;
		RETURN QUERY
		select * from tableUser;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
