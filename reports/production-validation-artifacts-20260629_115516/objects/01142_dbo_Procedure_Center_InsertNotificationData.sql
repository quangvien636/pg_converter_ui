-- ─── PROCEDURE→FUNCTION: center_insertnotificationdata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertnotificationdata(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertnotificationdata(
    IN devicetype character varying,
    IN modulename character varying,
    IN projectid character varying,
    IN devicekey character varying
) RETURNS SETOF record
AS $function$
DECLARE
    notificationno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	INSERT INTO Center_NotificationData (DeviceType, ModuleName, ProjectID, DeviceKey, JsonData)
	VALUES (DeviceType, ModuleName, ProjectID, DeviceKey, JsonData)


	NotificationNo := lastval();
	RETURN QUERY
	SELECT NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
