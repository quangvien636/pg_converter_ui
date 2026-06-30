-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtime_notices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_notices(date);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_notices(
    IN selecteddate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SelectedDate IS NULL THEN
	
		RETURN QUERY
		SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		ORDER BY NoticeNo DESC

	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
			W.TimeType, W.StartDate, W.EndDate, W.Content,W.Content_Ko,W.Content_Vn
		FROM WorkingTime_Notices W
		INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
		WHERE W.StartDate <= workingtime_getworkingtime_notices.selecteddate AND W.EndDate >= workingtime_getworkingtime_notices.selecteddate
		ORDER BY NoticeNo DESC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
