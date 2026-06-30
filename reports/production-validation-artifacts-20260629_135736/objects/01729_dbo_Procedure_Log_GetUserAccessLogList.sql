-- ─── PROCEDURE→FUNCTION: log_getuseraccessloglist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.log_getuseraccessloglist();
CREATE OR REPLACE FUNCTION public.log_getuseraccessloglist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


    RETURN QUERY
    SELECT LogNo, ClientIP, UserNo, AccDate, AccModule, UserName 
    FROM AccessLog WHERE UserNo = UserNo
    ORDER BY LogNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
