-- ─── PROCEDURE→FUNCTION: board_updatenotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_updatenotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying, character varying, boolean, xml, date);
CREATE OR REPLACE FUNCTION public.board_updatenotificationservice(
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
	CREATE TEMP TABLE tb AS SELECT /* TOP 1 */ NotificationNo = NotificationNo from  Center_NotificationService where CompanyNo = board_updatenotificationservice.companyno and ProjectCode = board_updatenotificationservice.projectcode and Connectionkey = board_updatenotificationservice.connectionkey 

	if(NotificationNo > 0)
	begin
		-- update main;
		update Center_NotificationService set
		CompanyNo = board_updatenotificationservice.companyno
		, ProjectCode = board_updatenotificationservice.projectcode
		, Connectionkey = board_updatenotificationservice.connectionkey
		, SendUserNo = board_updatenotificationservice.senduserno
		, RecipientUserNo = board_updatenotificationservice.recipientuserno
		, RecipientDepartNo = board_updatenotificationservice.recipientdepartno
		, StartDate = board_updatenotificationservice.startdate
		, EndDate = board_updatenotificationservice.enddate
		, RepeatType = board_updatenotificationservice.repeattype
		, RepeatOptions = board_updatenotificationservice.repeatoptions
		where NotificationNo = NotificationNo

		--DELETE FROM detail;
		DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo = NotificationNo
	END;
	ELSE
		-- INSERT INTO main;
		INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State, Execution)
		values (CompanyNo, ProjectCode, Connectionkey, SendUserNo,RecipientUserNo,RecipientDepartNo,StartDate,StartDate,RepeatType,RepeatOptions,State,Execution)

		-- get Notification ID
		select /* TOP 1 */ NotificationNo = NotificationNo from  Center_NotificationService where ProjectCode = board_updatenotificationservice.projectcode and Connectionkey = board_updatenotificationservice.connectionkey  
	END IF;

	-- INSERT INTO detail

	---- Create an internal representation of the XML document.  
	PERFORM sp_xml_preparedocument(docHandle OUTPUT, XmlDetail);
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
