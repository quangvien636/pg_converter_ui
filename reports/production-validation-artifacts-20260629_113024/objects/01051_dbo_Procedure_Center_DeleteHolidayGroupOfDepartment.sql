-- ─── PROCEDURE→FUNCTION: center_deleteholidaygroupofdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deleteholidaygroupofdepartment(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholidaygroupofdepartment(
    IN departno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_HolidayGroupOfDepartments WHERE DepartNo = center_deleteholidaygroupofdepartment.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
