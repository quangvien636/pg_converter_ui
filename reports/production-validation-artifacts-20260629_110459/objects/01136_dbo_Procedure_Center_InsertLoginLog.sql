-- ─── PROCEDURE→FUNCTION: center_insertloginlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertloginlog(integer, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertloginlog(
    IN userno integer,
    IN clientip character varying,
    IN logindate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_AccessLogs(UserNo,ClientIP,AccessDate,ApplicationNo)
	VALUES(UserNo, ClientIP, LoginDate, -10)
	
	INSERT INTO Center_LoginLogs (UserNo, ClientIP, LoginDate)
	VALUES (UserNo, ClientIP, LoginDate)
	

	LogNo := lastval();
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
