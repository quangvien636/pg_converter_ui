-- ─── FUNCTION: edmsreturnserial ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsreturnserial(integer, character varying, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.edmsreturnserial(
    id integer,
    serial character varying,
    userid character varying,
    getdate timestamp without time zone
) RETURNS character varying
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    id integer;
    temp character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

/*

,			Serial varchar(1000)
,			USERID NVARCHAR(50)
,	getdate	datetime
select		ID		= 10
,			Serial = '{2,Day}일 {Depart}과 {4,Year}년 {2,Month}월-{5,Serial}' 
,			USERID = 'ADMIN'
,			getdate	= NOW()
--*/


	,	return varchar(1000)
	,	DateType varchar(100)
	,	datelen int



	select temp = replace(replace(substring(Serial,STRPOS(Serial, '{'),STRPOS(Serial, '}') - (STRPOS(Serial, '{')-1)),'{',''),'}','')

	while temp is not null and temp <> ''
	begin
			set return = ''
			if(STRPOS(',temp, ') > 0)
			begin
				select datelen = convert(int,substring(temp,1,STRPOS(',temp, ') - 1))
			end

			if temp = 'Form'
			begin
				select return=public."EDMSReturnEACode"(ID)
			end
			else if temp = 'SaupCode'
			begin
				select return=SaupCode from EDMS_Saupjang where DocID = edmsreturnserial.id
			end
			else if temp = 'EDCode'
			begin
				select return=a.folderid from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='2' and a.docid=edmsreturnserial.id				
			end
			else if temp = 'FolderCode1'
			begin
				select return=a.folderid from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='1' and a.docid=edmsreturnserial.id				
			end
			else if temp = 'FolderCode2'
			begin
				select return=a.folderid from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='2' and a.docid=edmsreturnserial.id				
			end
			else if temp = 'FolderCode5'
			begin
				select return=a.folderid from edmsdocfolder a inner join edmstreeitem b on a.folderid = b.id where b.divid='5' and a.docid=edmsreturnserial.id				
			end
			else
			begin
			select	return = case 	when  temp = 'Depart' then d.Name	--부서
									when  temp = 'DepartCode' then (select ShortName from Organization_Departments org inner join edmsdocument ed on org.DepartNo=ed.departid where ed.id=edmsreturnserial.id)	--부서코드	
									when   STRPOS(temp, 'MaxSerial') > 0	then  right(replicate('0',10) || convert(varchar(10),(select Serial from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}',''))	),case when substring(temp,0,STRPOS(temp, 'MaxSerial')-1) >= (select len(Serial) from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}','')) then substring(temp,0,STRPOS(temp, 'MaxSerial')-1) else (select len(Serial) from EDMSSerial where KeyCode=replace(Serial,'{' || temp || '}','')) end )--채번시리얼						
									when   STRPOS(temp, 'Serial') > 0	then  right(replicate('0',10) || convert(varchar(10),ID),substring(temp,0,STRPOS(temp, 'Serial')-1))--시리얼
							  else	
									case substring(temp,STRPOS(',temp, ') || 1,len(temp) - STRPOS(',temp, '))
										when 'Day'  then right(replicate('0',datelen) || cast(datepart(Day,getdate) AS varchar),datelen)			
										when 'Month'  then right(replicate('0',datelen) || cast(datepart(Month,getdate) AS varchar),datelen)
										when 'Year'  then right(replicate('0',datelen) || cast(datepart(Year,getdate) AS varchar),datelen)
									end 	--날자							
							 end
				from Organization_Users u 
					left outer join Organization_BelongToDepartment b on u.UserNo=b.UserNo
					left outer join Organization_Departments d on b.DepartNo=d.DepartNo			
				where userid = edmsreturnserial.userid
			end		
			
			select Serial = replace(Serial,'{' || temp || '}',return)		
			
			select temp = replace(replace(substring(Serial,STRPOS(Serial, '{'),STRPOS(Serial, '}') - (STRPOS(Serial, '{')-1)),'{',''),'}','')
	end

	RETURN Serial;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
