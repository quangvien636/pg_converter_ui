-- ─── FUNCTION: dday_getnotificationdaylist ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getnotificationdaylist();
CREATE OR REPLACE FUNCTION public.dday_getnotificationdaylist(
) RETURNS TABLE(
    dayno text,
    reguserno text,
    moduserno text,
    moddate text,
    groupno text,
    typeno text,
    repeatoptions text,
    title text,
    content text,
    canhide text,
    notificationtype text,
    notificationtime text
)
AS $function$
BEGIN



RETURN QUERY
SELECT  DD.dayno,
		DD.reguserno  ,
		DD.moduserno  ,
		DD.moddate ,
		DD.groupno  ,
		DD.typeno  ,
		DD.repeatoptions  ,
		DD.title  ,
		DD.content  ,
		DD.canhide ,
		DN.NotificationType,
		DN.NotificationTime
	FROM dday_days DD
	INNER JOIN Dday_Notifications DN ON DN.DayNo=DD.DayNo
	WHERE  DN.NotificationType<2;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
