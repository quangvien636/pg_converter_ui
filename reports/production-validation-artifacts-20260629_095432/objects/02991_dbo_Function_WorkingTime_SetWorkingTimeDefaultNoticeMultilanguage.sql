-- ─── FUNCTION: workingtime_setworkingtimedefaultnoticemultilanguage ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimedefaultnoticemultilanguage(integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimedefaultnoticemultilanguage(
    noticeno integer,
    reguserno integer,
    timetype integer,
    content character varying,
    content_ko character varying
) RETURNS void
AS $function$
BEGIN

	IF NoticeNo=0
		BEGIN;
			INSERT INTO WorkingTime_DefaultNotices (RegUserNo, RegDate, TimeType,Content,Content_Ko,Content_Vn)
			VALUES (RegUserNo, NOW(), TimeType,Content,Content_Ko,Content_Vn)
		END
	ELSE
		BEGIN;
			UPDATE WorkingTime_DefaultNotices
			SET RegUserNo=workingtime_setworkingtimedefaultnoticemultilanguage.reguserno,RegDate=NOW(),TimeType=workingtime_setworkingtimedefaultnoticemultilanguage.timetype,Content=workingtime_setworkingtimedefaultnoticemultilanguage.content,Content_Ko=workingtime_setworkingtimedefaultnoticemultilanguage.content_ko,Content_Vn=Content_Vn
			WHERE NoticeNo=workingtime_setworkingtimedefaultnoticemultilanguage.noticeno
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
