-- ─── FUNCTION: workingtime_getworkingtime_notices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_notices(date);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_notices(
    selecteddate date
) RETURNS TABLE(
    noticeno text,
    reguserno text,
    username text,
    regdate text,
    timetype text,
    startdate text,
    enddate text,
    content text,
    content_ko text,
    content_vn text
)
AS $function$
BEGIN


	IF SelectedDate IS NULL BEGIN
	
		RETURN QUERY
		SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		ORDER BY NoticeNo DESC

	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		WHERE W.StartDate <= workingtime_getworkingtime_notices.selecteddate AND W.EndDate >= workingtime_getworkingtime_notices.selecteddate
		ORDER BY NoticeNo DESC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
