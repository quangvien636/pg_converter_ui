-- ─── PROCEDURE→FUNCTION: vacation_cancelrequest2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_cancelrequest2(integer);
CREATE OR REPLACE FUNCTION public.vacation_cancelrequest2(
    IN p_rid integer
) RETURNS void
AS $function$
BEGIN

update  Vacation_Requests 
StatusAdmin := 1;
where Vacation_Requests.RequestId = vacation_cancelrequest2.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
