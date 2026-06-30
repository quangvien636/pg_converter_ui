-- ─── FUNCTION: workingtime_getworkingtimenotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimenotices(date, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimenotices(
    selecteddate date,
    locationno integer DEFAULT 0
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
    content_vn text,
    locationno text
)
AS $function$
BEGIN


	IF SelectedDate IS NULL BEGIN
	
		RETURN QUERY
		SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn,LocationNo
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		Where LocationNo= workingtime_getworkingtimenotices.locationno
		ORDER BY NoticeNo DESC

	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn,LocationNo
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		WHERE LocationNo= workingtime_getworkingtimenotices.locationno And W.StartDate <= workingtime_getworkingtimenotices.selecteddate AND W.EndDate >= workingtime_getworkingtimenotices.selecteddate
		ORDER BY TimeType ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
