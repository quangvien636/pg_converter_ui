-- ─── FUNCTION: workingtime_getworkingtime_noticestype ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_noticestype(date, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_noticestype(
    selecteddate date,
    type integer
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
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		RETURN QUERY
		SELECT /* TOP 1 */ W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		WHERE W.StartDate <= workingtime_getworkingtime_noticestype.selecteddate AND W.EndDate >= workingtime_getworkingtime_noticestype.selecteddate AND TimeType=workingtime_getworkingtime_noticestype.type
		ORDER BY NoticeNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
