-- ─── PROCEDURE→FUNCTION: vacation_aplyrequest ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_aplyrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_aplyrequest(
    IN p_rid integer
) RETURNS void
AS $function$
BEGIN

update  Vacation_Requests 
StatusAdmin := 2;
where Vacation_Requests.RequestId = vacation_aplyrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
