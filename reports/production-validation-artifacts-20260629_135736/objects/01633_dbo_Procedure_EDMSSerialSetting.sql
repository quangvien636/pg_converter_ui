-- ─── PROCEDURE→FUNCTION: edmsserialsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.edmsserialsetting(integer);
CREATE OR REPLACE FUNCTION public.edmsserialsetting(
    IN id integer
) RETURNS SETOF record
AS $function$
DECLARE
    serial character varying;
    temp character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

,		USERID NVARCHAR(50)
,		getdate datetime

SELECT (SELECT VALUEDATA INTO serial FROM EDMSConfiguration WHERE KEYCODE = 'DocSerial')
,		USERID = WriterID
,		getdate = RegDate
from EDMSDocument where ID=edmsserialsetting.id



	,	return varchar(1000)
	,	DateType varchar(100)
	,	datelen int



	temp := (replace(replace(substring(Serial,STRPOS(Serial, '{'),STRPOS(Serial, '}') - (STRPOS(Serial, '{')-1)),'{',''),'}',''));
	WHILE temp is not null and temp <> '' LOOP
			return := '';
			if(STRPOS(',temp, ') > 0)
			begin
				datelen := (convert(int,substring(temp,1,STRPOS(',temp, ') - 1)));
			END;

			IF temp = 'Form' THEN
				return := (public."EDMSReturnEACode"(ID));
			END IF;
			ELSIF temp = 'SaupCode' THEN
				SELECT SaupCode INTO return from EDMS_Saupjang where DocID = edmsserialsetting.id
			END IF;
			ELSIF temp = 'EDCode' THEN
				SELECT a.folderid INTO return from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='2' and a.docid=edmsserialsetting.id				
			END IF;
			ELSIF temp = 'FolderCode1' THEN
				SELECT a.folderid INTO return from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='1' and a.docid=edmsserialsetting.id				
			END IF;
			ELSIF temp = 'FolderCode2' THEN
				SELECT a.folderid INTO return from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='2' and a.docid=edmsserialsetting.id				
			END IF;
			ELSIF temp = 'FolderCode5' THEN
				SELECT a.folderid INTO return from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='5' and a.docid=edmsserialsetting.id				
			END IF;
			ELSE
			return := (case 	when  temp = 'Depart' then d.Name	--부서);
									when  temp = 'DepartCode' then (select ShortName from Organization_Departments org inner join edmsdocument ed on org.DepartNo=ed.departid where ed.id=edmsserialsetting.id)	--부서코드	
									when  STRPOS(temp, 'MaxSerial') > 0	then  right(replicate('0',10) + convert(varchar(10),(select Serial from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}',''))	),case when substring(temp,0,STRPOS(temp, 'MaxSerial')-1) >= (select len(Serial) from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}','')) then substring(temp,0,STRPOS(temp, 'MaxSerial')-1) else (select len(Serial) from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}','')) end )--채번시리얼
									when   STRPOS(temp, 'Serial') > 0	then  right(replicate('0',10) + convert(varchar(10),ID),substring(temp,0,STRPOS(temp, 'Serial')-1))--시리얼								
							  ELSE
									case substring(temp,STRPOS(',temp, ') + 1,len(temp) - STRPOS(',temp, '))
										when 'Day'  then right(replicate('0',datelen) + cast(datepart(Day,getdate) AS varchar),datelen)			
										when 'Month'  then right(replicate('0',datelen) + cast(datepart(Month,getdate) AS varchar),datelen)
										when 'Year'  then right(replicate('0',datelen) + cast(datepart(Year,getdate) AS varchar),datelen)
									end 	--날자							
							 END IF;
				from Organization_Users u 
					left outer join Organization_BelongToDepartment b on u.UserNo=b.UserNo
					left outer join Organization_Departments d on b.DepartNo=d.DepartNo
				where userid = USERID
			END LOOP;
			
			Serial := (replace(Serial,'{' || temp || '}',return));
			temp := (replace(replace(substring(Serial,STRPOS(Serial, '{'),STRPOS(Serial, '}') - (STRPOS(Serial, '{')-1)),'{',''),'}',''));
			IF STRPOS(temp, 'Serial') > 0 THEN
				if exists (select * from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}',''))
				begin;
					update EDMSSerial set Serial=Serial+1 where KeyCode=replace(Serial,'{' || temp || '}','')
				END;
				ELSE;
					insert into EDMSSerial(KeyCode,Serial) values (replace(Serial,'{' || temp || '}',''),(select COALESCE(MAX(id),1) from EDMSDocument where Serial ILIKE replace(Serial,'{' || temp || '}','')+'%'))
				END IF;
				
			END IF;
	END;

	--select Serial
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
