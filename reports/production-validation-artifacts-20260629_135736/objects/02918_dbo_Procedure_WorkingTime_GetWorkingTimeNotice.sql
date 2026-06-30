-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtimenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimenotice(boolean, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimenotice(
    IN isdefault boolean,
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDefault = TRUE THEN
		
		RETURN QUERY
		SELECT NoticeNo, TimeType, Content,Content_Ko,Content_Vn,0 as LocationNo
		FROM WorkingTime_DefaultNotices
		WHERE NoticeNo = workingtime_getworkingtimenotice.noticeno
		
	END IF;

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
