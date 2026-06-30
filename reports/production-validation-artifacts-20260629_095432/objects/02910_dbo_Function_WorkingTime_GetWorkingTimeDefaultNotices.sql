-- ─── FUNCTION: workingtime_getworkingtimedefaultnotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimedefaultnotices();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimedefaultnotices(
) RETURNS TABLE(
    noticeno text,
    reguserno text,
    username text,
    regdate text,
    timetype text,
    content text,
    content_ko text,
    content_vn text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
		W.TimeType, W.Content,W.Content_Ko,W.Content_Vn
	FROM WorkingTime_DefaultNotices W
	INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
	ORDER BY TimeType ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
