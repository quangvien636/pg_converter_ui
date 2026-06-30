-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtimemessages ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimemessages();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimemessages(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT W.MessageNo, W.RegUserNo AS UserNo, U.Name AS UserName, U.UserPhoto, W.RegDate, W.Message
	FROM WorkingTimeMessages W
	INNER JOIN Users U ON U.UserNo = W.RegUserNo
	ORDER BY MessageNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
