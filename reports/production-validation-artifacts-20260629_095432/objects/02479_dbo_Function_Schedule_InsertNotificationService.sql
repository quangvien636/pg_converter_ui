-- ─── FUNCTION: schedule_insertnotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertnotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying, character varying, boolean, xml, date);
CREATE OR REPLACE FUNCTION public.schedule_insertnotificationservice(
    companyno integer,
    projectcode character varying,
    connectionkey integer,
    senduserno integer,
    recipientuserno character varying,
    recipientdepartno character varying,
    startdate date,
    enddate date,
    repeattype character varying,
    repeatoptions character varying,
    state boolean,
    xmldetail xml,
    execution date DEFAULT NULL
) RETURNS void
AS $function$
DECLARE
    notificationno integer;
    dochandle integer;
BEGIN


	-- declare

	-- INSERT INTO main;
	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State, Execution)
	values (CompanyNo, ProjectCode, Connectionkey, SendUserNo,RecipientUserNo,RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions,State,Execution)

	-- get Notification ID
	SET NotificationNo = lastval() 

	-- INSERT INTO detail

	---- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument docHandle OUTPUT, XmlDetail 
	SELECT * into #tb 
	FROM OPENXML (docHandle, '/root/NotificationServiceDetails')  WITH (NotificationNo  int, AlarmCode varchar(50), AlarmStartTime varchar(500), AlarmTime int, Title nvarchar(100), Id int)

	SELECT
	otificationServiceDetail.value('Id','INT') AS Id, --ATTRIBUTE
	otificationServiceDetail.value('(Title/text())1','text') AS Title,
	otificationServiceDetail.value('(ContentJson/text())1','text') AS ContentJson
	into #tb2
	FROM
	XmlDetail.nodes('/root/NotificationServiceDetails/NotificationServiceDetail')AS TEMPTABLE(otificationServiceDetail)

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from #tb a
	join #tb2 b on a.Id = b.Id

	drop table #tb
	drop table #tb2
	EXEC sp_xml_removedocument docHandle;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
