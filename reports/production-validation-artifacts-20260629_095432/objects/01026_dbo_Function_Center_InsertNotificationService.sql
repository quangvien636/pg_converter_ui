-- ─── FUNCTION: center_insertnotificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertnotificationservice(integer, character varying, integer, integer, character varying, character varying, date, date, character varying);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice(
    companyno integer,
    projectcode character varying,
    connectionkey integer,
    senduserno integer,
    recipientuserno character varying,
    recipientdepartno character varying,
    startdate date,
    enddate date,
    repeattype character varying
) RETURNS TABLE(
    notificationno text
)
AS $function$
DECLARE
    notificationno bigint;
BEGIN


	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,
		RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions)
	values(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,
		RecipientDepartNo,StartDate,EndDate,RepeatType,RepeatOptions)


	SET NotificationNo = COALESCE(lastval(), 0)

	RETURN QUERY
	SELECT NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
