-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimedefaultnoticemultilanguage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimedefaultnoticemultilanguage(integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimedefaultnoticemultilanguage(
    IN noticeno integer,
    IN reguserno integer,
    IN timetype integer,
    IN content character varying,
    IN content_ko character varying
) RETURNS void
AS $function$
BEGIN

	IF NoticeNo=0 THEN;
			INSERT INTO WorkingTime_DefaultNotices (RegUserNo, RegDate, TimeType,Content,Content_Ko,Content_Vn)
			VALUES (RegUserNo, NOW(), TimeType,Content,Content_Ko,Content_Vn)
		END IF;
	ELSE;
			UPDATE WorkingTime_DefaultNotices
			RegUserNo := workingtime_setworkingtimedefaultnoticemultilanguage.reguserno,RegDate=NOW(),TimeType=workingtime_setworkingtimedefaultnoticemultilanguage.timetype,Content=workingtime_setworkingtimedefaultnoticemultilanguage.content,Content_Ko=workingtime_setworkingtimedefaultnoticemultilanguage.content_ko,Content_Vn=Content_Vn;
			WHERE NoticeNo=workingtime_setworkingtimedefaultnoticemultilanguage.noticeno
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
