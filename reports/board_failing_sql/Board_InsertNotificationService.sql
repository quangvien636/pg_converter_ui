-- ─── PROCEDURE→FUNCTION: board_insertnotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_insertnotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying, character varying, boolean, xml, date);
CREATE OR REPLACE FUNCTION public.board_insertnotificationservice(
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
    notificationno integer;
    dochandle integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare


	-- INSERT INTO main;
	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State, Execution)
	values (CompanyNo, ProjectCode, Connectionkey, SendUserNo,RecipientUserNo,RecipientDepartNo,StartDate,StartDate,RepeatType,RepeatOptions,State,Execution);

	-- get Notification ID
	SELECT NotificationNo INTO notificationno FROM Center_NotificationService where ProjectCode = board_insertnotificationservice.projectcode and Connectionkey = board_insertnotificationservice.connectionkey;

	-- INSERT INTO detail

	---- Create an internal representation of the XML document.
-- TODO: XML shredding removed — rewrite as xmltable
	CREATE TEMP TABLE tb ON COMMIT DROP AS SELECT * FROM xmltable('/*' PASSING NULL::xml COLUMNS NotificationNo integer PATH 'NotificationNo', AlarmCode text PATH 'AlarmCode', AlarmStartTime text PATH 'AlarmStartTime', AlarmTime integer PATH 'AlarmTime', Title text PATH 'Title', Id integer PATH 'Id') /* TODO: verify XML path and column mappings */;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS SELECT otificationServiceDetail.value('Id','INT') AS Id, --ATTRIBUTE
	otificationServiceDetail.value('(Title/text())1','text') AS Title,
	otificationServiceDetail.value('(ContentJson/text())1','text') AS ContentJson FROM
	XmlDetail.nodes('/root/NotificationServiceDetails/NotificationServiceDetail')AS TEMPTABLE(otificationServiceDetail);

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id;

	DROP TABLE IF EXISTS tb;
	DROP TABLE IF EXISTS tb2;
	PERFORM sp_xml_removedocument(docHandle);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.