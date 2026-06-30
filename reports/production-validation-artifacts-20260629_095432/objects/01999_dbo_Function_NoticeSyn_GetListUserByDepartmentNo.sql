-- ─── FUNCTION: noticesyn_getlistuserbydepartmentno ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getlistuserbydepartmentno();
CREATE OR REPLACE FUNCTION public.noticesyn_getlistuserbydepartmentno(
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
AS $function$
DECLARE
    tabledeparment table(
rownum int identity,
departno int

);
    departno integer;
BEGIN




UserNo int,
UserID nvarchar(200),
DepartNo int,
DepartName nvarchar(200)
)

insert into tableDeparment
RETURN QUERY
select DepartNo
 from Organization_Departments where Enabled = TRUE


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM tableDeparment)

WHILE (RowIndex <= MaxIndex) BEGIN

			SELECT DepartNo = DepartNo
			FROM tableDeparment
			WHERE RowNum = RowIndex
			
			insert into tableUser
			RETURN QUERY
			select u.userNo, u.UserID,b.DepartNo
			,(case when LangCode='EN' then d.Name_EN when LangCode='CH' then d.Name_CH when LangCode='JP' then d.Name_JP when LangCode='VN' then d.Name_VN else d.Name end) as Name 
			from Organization_BelongToDepartment b 
			inner join Organization_Users u on b.UserNo=u.Userno 
			inner join Organization_Departments d on d.DepartNo=b.departno
			where b.departno=DepartNo and u.Enabled = TRUE 


			SET RowIndex = RowIndex + 1

		END
		RETURN QUERY
		select * from tableUser;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
