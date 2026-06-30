-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimenoticemultilanguage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimenoticemultilanguage(integer, integer, integer, date, date, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimenoticemultilanguage(
    IN noticeno integer,
    IN reguserno integer,
    IN timetype integer,
    IN startdate date,
    IN enddate date,
    IN content character varying,
    IN content_ko character varying,
    IN locationno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF NoticeNo=0 THEN;
			INSERT INTO WorkingTime_Notices (LocationNo,RegUserNo, RegDate, TimeType, StartDate, EndDate, Content,Content_Ko,Content_Vn)
			VALUES (LocationNo,RegUserNo, NOW(), TimeType, StartDate, EndDate, Content,Content_Ko,Content_Vn)
		END IF;
	ELSE;
			UPDATE WorkingTime_Notices
			RegUserNo := workingtime_setworkingtimenoticemultilanguage.reguserno,RegDate=NOW(),TimeType=workingtime_setworkingtimenoticemultilanguage.timetype,StartDate=workingtime_setworkingtimenoticemultilanguage.startdate,EndDate=workingtime_setworkingtimenoticemultilanguage.enddate,Content=workingtime_setworkingtimenoticemultilanguage.content,Content_Ko=workingtime_setworkingtimenoticemultilanguage.content_ko,Content_Vn=Content_Vn;
			WHERE NoticeNo=workingtime_setworkingtimenoticemultilanguage.noticeno
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
