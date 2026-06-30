-- ─── PROCEDURE→FUNCTION: main_getusersetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.main_getusersetting(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT UseCustomDashBoard, DashBoardDisplayOrder, IsDashBoardChangeNotification, FirstProjectCode
	FROM Main_UserSettings
	WHERE UserNo = main_getusersetting.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
