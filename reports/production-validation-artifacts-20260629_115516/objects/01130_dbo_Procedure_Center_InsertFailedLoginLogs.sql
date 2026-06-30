-- ─── PROCEDURE→FUNCTION: center_insertfailedloginlogs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertfailedloginlogs(integer, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertfailedloginlogs(
    IN userno integer,
    IN clientip character varying,
    IN failedlogindate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_FailedLoginLogs (UserNo, ClientIP, FailedLoginDate)
	VALUES (UserNo, ClientIP, FailedLoginDate)
	

	LogNo := lastval();
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
