-- ─── PROCEDURE→FUNCTION: schedule_updatenotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_updatenotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying, character varying, boolean, xml, date);
CREATE OR REPLACE FUNCTION public.schedule_updatenotificationservice(
    IN companyno integer,
    IN projectcode character varying,
    IN connectionkey integer,
    IN senduserno integer,
    IN recipientuserno character varying,
    IN recipientdepartno character varying,
    IN startdate date,
    IN enddate date,
    IN repeattype character varying,
    IN repeatoptions character varying,
    IN state boolean,
    IN xmldetail xml,
    IN execution date DEFAULT NULL
) RETURNS void
AS $function$
DECLARE
    dochandle integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- get Notification ID
	CREATE TEMP TABLE tb AS SELECT /* TOP 1 */ NotificationNo = NotificationNo from  Center_NotificationService where CompanyNo = schedule_updatenotificationservice.companyno and ProjectCode = schedule_updatenotificationservice.projectcode and Connectionkey = schedule_updatenotificationservice.connectionkey 

	if(NotificationNo > 0)
	begin
		-- update main;
		update Center_NotificationService set
		CompanyNo = schedule_updatenotificationservice.companyno
		, ProjectCode = schedule_updatenotificationservice.projectcode
		, Connectionkey = schedule_updatenotificationservice.connectionkey
		, SendUserNo = schedule_updatenotificationservice.senduserno
		, RecipientUserNo = schedule_updatenotificationservice.recipientuserno
		, RecipientDepartNo = schedule_updatenotificationservice.recipientdepartno
		, StartDate = schedule_updatenotificationservice.startdate
		, EndDate = schedule_updatenotificationservice.enddate
		, RepeatType = schedule_updatenotificationservice.repeattype
		, RepeatOptions = schedule_updatenotificationservice.repeatoptions
		where NotificationNo = NotificationNo

		--DELETE FROM detail;
		DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo = NotificationNo
	END;
	ELSE
		-- INSERT INTO main;
		INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State, Execution)
		values (CompanyNo, ProjectCode, Connectionkey, SendUserNo,RecipientUserNo,RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions,State,Execution)

		-- get Notification ID
		select /* TOP 1 */ NotificationNo = NotificationNo from  Center_NotificationService where ProjectCode = schedule_updatenotificationservice.projectcode and Connectionkey = schedule_updatenotificationservice.connectionkey  
	END IF;

	-- INSERT INTO detail

	---- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument docHandle OUTPUT, XmlDetail 
	SELECT * FROM OPENXML (docHandle, '/root/NotificationServiceDetails')  WITH (NotificationNo  int, AlarmCode varchar(50), AlarmStartTime varchar(500), AlarmTime int, Id int)

	CREATE TEMP TABLE tb2 AS SELECT otificationServiceDetail.value('Id','INT') AS Id, --ATTRIBUTE
	otificationServiceDetail.value('(Title/text())1','text') AS Title,
	otificationServiceDetail.value('(ContentJson/text())1','text') AS ContentJson FROM
	XmlDetail.nodes('/root/NotificationServiceDetails/NotificationServiceDetail')AS TEMPTABLE(otificationServiceDetail)

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id

	drop table tb
	drop table tb2
	PERFORM sp_xml_removedocument(docHandle);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
