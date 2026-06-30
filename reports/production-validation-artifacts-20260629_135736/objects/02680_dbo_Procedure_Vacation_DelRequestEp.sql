-- ─── PROCEDURE→FUNCTION: vacation_delrequestep ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_delrequestep(integer);
CREATE OR REPLACE FUNCTION public.vacation_delrequestep(
    IN p_no integer
) RETURNS void
AS $function$
BEGIN

				DELETE FROM Vacation_RequestEps 
				where UsernoI = vacation_delrequestep.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
