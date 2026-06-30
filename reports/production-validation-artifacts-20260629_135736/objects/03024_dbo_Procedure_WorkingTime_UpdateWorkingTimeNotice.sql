-- ─── PROCEDURE→FUNCTION: workingtime_updateworkingtimenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimenotice(boolean, integer, integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimenotice(
    IN isdefault boolean,
    IN noticeno integer,
    IN reguserno integer,
    IN timetype integer,
    IN startdate date,
    IN enddate date
) RETURNS void
AS $function$
BEGIN


	IF IsDefault = TRUE THEN

		UPDATE WorkingTime_DefaultNotices SET RegUserNo = workingtime_updateworkingtimenotice.reguserno, RegDate = NOW(),
			TimeType = workingtime_updateworkingtimenotice.timetype, Content = Content
		WHERE NoticeNo = workingtime_updateworkingtimenotice.noticeno
		
	END IF;
	
	ELSE BEGIN
	
		UPDATE WorkingTime_Notices SET RegUserNo = workingtime_updateworkingtimenotice.reguserno, RegDate = NOW(), TimeType = workingtime_updateworkingtimenotice.timetype,
			StartDate = workingtime_updateworkingtimenotice.startdate, EndDate = workingtime_updateworkingtimenotice.enddate, Content = Content
		WHERE NoticeNo = workingtime_updateworkingtimenotice.noticeno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
