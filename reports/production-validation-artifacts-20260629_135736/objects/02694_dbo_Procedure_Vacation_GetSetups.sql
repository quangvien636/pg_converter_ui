-- ─── PROCEDURE→FUNCTION: vacation_getsetups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_getsetups();
CREATE OR REPLACE FUNCTION public.vacation_getsetups(
) RETURNS void
AS $function$
BEGIN

	if((select count(1) from Vacation_Setups) = 0);
		insert into Vacation_Setups(val) values (0)

	SELECT 
		*
	FROM  Vacation_Setups R;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
