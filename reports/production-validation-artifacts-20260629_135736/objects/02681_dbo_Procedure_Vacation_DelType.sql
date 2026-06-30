-- ─── PROCEDURE→FUNCTION: vacation_deltype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_deltype(integer);
CREATE OR REPLACE FUNCTION public.vacation_deltype(
    IN p_id integer
) RETURNS void
AS $function$
BEGIN

DELETE FROM Vacation_Types
     WHERE TypeId = vacation_deltype.p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
