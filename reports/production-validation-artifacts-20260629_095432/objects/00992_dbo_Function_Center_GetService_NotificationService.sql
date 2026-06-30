-- ─── FUNCTION: center_getservice_notificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getservice_notificationservice();
CREATE OR REPLACE FUNCTION public.center_getservice_notificationservice(
) RETURNS TABLE(
    notificationno text,
    companyno text,
    projectcode text,
    connectionkey text,
    senduserno text,
    recipientuserno text,
    recipientdepartno text,
    startdate text,
    enddate text,
    repeattype text,
    repeatoptions text,
    state text,
    execution text,
    crewchatroomno text
)
AS $function$
BEGIN


	RETURN QUERY
	select 
	NotificationNo
	,CompanyNo
	,ProjectCode
	,Connectionkey
	,SendUserNo
	,RecipientUserNo
	,RecipientDepartNo
	,StartDate
	,EndDate
	,RepeatType
	,RepeatOptions
	,COALESCE(State,0) as State
	,Execution
	,CrewChatRoomNo
	from Center_NotificationService
	where COALESCE(State,0) = 0
	order by NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
