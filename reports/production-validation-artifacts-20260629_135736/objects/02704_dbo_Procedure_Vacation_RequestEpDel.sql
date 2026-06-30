-- ─── PROCEDURE→FUNCTION: vacation_requestepdel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_requestepdel(integer);
CREATE OR REPLACE FUNCTION public.vacation_requestepdel(
    IN p_no integer
) RETURNS void
AS $function$
BEGIN

				DELETE FROM Vacation_RequestEps 

				where RequestId = vacation_requestepdel.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
