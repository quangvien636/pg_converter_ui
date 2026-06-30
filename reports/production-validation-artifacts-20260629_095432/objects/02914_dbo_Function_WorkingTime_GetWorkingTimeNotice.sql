-- ─── FUNCTION: workingtime_getworkingtimenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimenotice(boolean, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimenotice(
    isdefault boolean,
    noticeno integer
) RETURNS TABLE(
    noticeno text,
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


	IF IsDefault = TRUE BEGIN
		
		RETURN QUERY
		SELECT NoticeNo, TimeType, Content,Content_Ko,Content_Vn,0 as LocationNo
		FROM WorkingTime_DefaultNotices
		WHERE NoticeNo = workingtime_getworkingtimenotice.noticeno
		
	END

	ELSE BEGIN
	
		RETURN QUERY
		SELECT NoticeNo, TimeType, StartDate, EndDate, Content,Content_Ko,Content_Vn, LocationNo
		FROM WorkingTime_Notices
		WHERE NoticeNo = workingtime_getworkingtimenotice.noticeno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
