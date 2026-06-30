-- ─── PROCEDURE→FUNCTION: vacation_delrequest ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_delrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_delrequest(
    IN p_rid integer
) RETURNS void
AS $function$
BEGIN

delete from Vacation_Requests  where Vacation_Requests.RequestId = vacation_delrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
