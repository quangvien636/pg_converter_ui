-- ─── FUNCTION: crew_insertnotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crew_insertnotificationservice(integer, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.crew_insertnotificationservice(
    senduserno integer,
    recipientuserno character varying,
    title character varying,
    content character varying,
    crewchatroomno integer DEFAULT 0
) RETURNS void
AS $function$
DECLARE
    notificationno bigint;
BEGIN



	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo
	,RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions,State,CrewChatRoomNo)
	values(1,'API',0,SendUserNo,RecipientUserNo,'',Convert(varchar, NOW(),23),Convert(varchar, NOW(),23)
	,'CheckSpecificDday','{"Interval":"0","Luner":"1","HolidayCondition":"1","HolidayCode":"ko"}',0, CrewChatRoomNo)

	SET NotificationNo = lastval()

	INSERT INTO Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime,Alarm_Time
	,Title,Content_Json)
	values(NotificationNo,'crewchat',NOW(),0,Title,'{ "Url":"","Message":"' || Content || '"}');
	--INSERT INTO Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime,Alarm_Time
	--,Title,Content_Json)
	--values(NotificationNo,'mail',NOW(),0,Title,Content)
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
