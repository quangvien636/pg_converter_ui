-- ─── FUNCTION: schedule_addnotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_addnotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_addnotificationservice(
    p_cno integer,
    p_pcode character varying,
    p_connectionkey integer,
    p_senduserno integer,
    p_recipientuserno character varying,
    p_recipientdepartno character varying,
    p_startdate date,
    p_enddate date,
    p_repeattype character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    notificationno integer;
BEGIN


	-- declare

	-- INSERT INTO main;
	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State)
	values (p_cNo, p_PCode, p_Connectionkey, p_SendUserNo,p_RecipientUserNo,p_RecipientDepartNo,p_StartDate,p_EndDate,p_RepeatType,p_RepeatOptions,0)
	SELECT NotificationNo = lastval()
	RETURN QUERY
	select NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
