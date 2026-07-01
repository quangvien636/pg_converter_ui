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
	-- TODO: map SQL Server xml.nodes/value expressions to PostgreSQL XMLTABLE
SELECT NULL::integer AS Id, NULL::text AS Title, NULL::text AS ContentJson WHERE FALSE;

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id;

	DROP TABLE IF; EXISTS tb;
	DROP TABLE IF; EXISTS tb2;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.