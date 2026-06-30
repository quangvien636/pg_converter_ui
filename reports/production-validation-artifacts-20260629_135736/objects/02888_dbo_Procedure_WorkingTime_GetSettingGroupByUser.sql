-- ─── PROCEDURE→FUNCTION: workingtime_getsettinggroupbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getsettinggroupbyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsettinggroupbyuser(
    IN p_uid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select g.*
	from Organization_Users u 
	LEFT JOIN WorkingTime_SettingGroup g
	ON U.GroupId = g.Id
	where u.UserNo = workingtime_getsettinggroupbyuser.p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
