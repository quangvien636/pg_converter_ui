-- ─── PROCEDURE→FUNCTION: workingtime_setdevicesid2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_setdevicesid2(integer, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_setdevicesid2(
    IN p_uno integer,
    IN p_vs character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		UPDATE WorkingTime_AllowDevices
				verson := workingtime_setdevicesid2.p_vs,;
				SessionId = p_sid
				WHERE UserNo = workingtime_setdevicesid2.p_uno 

	RETURN QUERY
	select 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
