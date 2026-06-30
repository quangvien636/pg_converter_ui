-- ─── FUNCTION: workingtime_updateworkingtimenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimenotice(boolean, integer, integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimenotice(
    isdefault boolean,
    noticeno integer,
    reguserno integer,
    timetype integer,
    startdate date,
    enddate date
) RETURNS void
AS $function$
BEGIN


	IF IsDefault = TRUE BEGIN

		UPDATE WorkingTime_DefaultNotices SET RegUserNo = workingtime_updateworkingtimenotice.reguserno, RegDate = NOW(),
			TimeType = workingtime_updateworkingtimenotice.timetype, Content = Content
		WHERE NoticeNo = workingtime_updateworkingtimenotice.noticeno
		
	END
	
	ELSE BEGIN
	
		UPDATE WorkingTime_Notices SET RegUserNo = workingtime_updateworkingtimenotice.reguserno, RegDate = NOW(), TimeType = workingtime_updateworkingtimenotice.timetype,
			StartDate = workingtime_updateworkingtimenotice.startdate, EndDate = workingtime_updateworkingtimenotice.enddate, Content = Content
		WHERE NoticeNo = workingtime_updateworkingtimenotice.noticeno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
