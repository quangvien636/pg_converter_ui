-- ─── FUNCTION: workingtime_setworkingtimenoticemultilanguage ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimenoticemultilanguage(integer, integer, integer, date, date, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimenoticemultilanguage(
    noticeno integer,
    reguserno integer,
    timetype integer,
    startdate date,
    enddate date,
    content character varying,
    content_ko character varying,
    locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF NoticeNo=0
		BEGIN;
			INSERT INTO WorkingTime_Notices (LocationNo,RegUserNo, RegDate, TimeType, StartDate, EndDate, Content,Content_Ko,Content_Vn)
			VALUES (LocationNo,RegUserNo, NOW(), TimeType, StartDate, EndDate, Content,Content_Ko,Content_Vn)
		END
	ELSE
		BEGIN;
			UPDATE WorkingTime_Notices
			SET RegUserNo=workingtime_setworkingtimenoticemultilanguage.reguserno,RegDate=NOW(),TimeType=workingtime_setworkingtimenoticemultilanguage.timetype,StartDate=workingtime_setworkingtimenoticemultilanguage.startdate,EndDate=workingtime_setworkingtimenoticemultilanguage.enddate,Content=workingtime_setworkingtimenoticemultilanguage.content,Content_Ko=workingtime_setworkingtimenoticemultilanguage.content_ko,Content_Vn=Content_Vn
			WHERE NoticeNo=workingtime_setworkingtimenoticemultilanguage.noticeno
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
