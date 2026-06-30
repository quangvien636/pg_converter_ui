-- ─── FUNCTION: center_deleteholidaygroupofdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteholidaygroupofdepartment(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholidaygroupofdepartment(
    departno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_HolidayGroupOfDepartments WHERE DepartNo = center_deleteholidaygroupofdepartment.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
