-- ─── PROCEDURE→FUNCTION: center_getuserall_notificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getuserall_notificationservice();
CREATE OR REPLACE FUNCTION public.center_getuserall_notificationservice(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select A.UserNo,A.UserID,A.Name,A.Password,A.MailAddress from Organization_Users A
	join Organization_BelongToDepartment B
	on A.UserNo = B.UserNo 
	where A.Enabled = TRUE and UserID != 'crewnotifer' and B.IsDefault = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
