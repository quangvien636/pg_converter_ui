-- ─── FUNCTION: workingtime_getworkingtime_defaultnotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_defaultnotices();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_defaultnotices(
) RETURNS TABLE(
    noticeno text,
    reguserno text,
    username text,
    regdate text,
    timetype text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
		W.TimeType, W.Content
	FROM WorkingTime_DefaultNotices W
	INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
	ORDER BY TimeType ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
