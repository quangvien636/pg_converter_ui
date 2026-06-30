-- ─── PROCEDURE→FUNCTION: vacation_getrequest ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_getrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_getrequest(
    IN p_rid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


RETURN QUERY
select * from  Vacation_Requests 
where Vacation_Requests.RequestId = vacation_getrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
