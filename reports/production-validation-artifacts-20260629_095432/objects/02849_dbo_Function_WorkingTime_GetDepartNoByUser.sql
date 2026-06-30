-- ─── FUNCTION: workingtime_getdepartnobyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getdepartnobyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getdepartnobyuser(
    userno integer
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DepartNo FROM  Organization_BelongToDepartment where UserNo = workingtime_getdepartnobyuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
