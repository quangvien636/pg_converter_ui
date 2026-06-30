-- ─── FUNCTION: workingtime_removsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_removsetting(integer);
CREATE OR REPLACE FUNCTION public.workingtime_removsetting(
    p_uid integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	SET GroupId = NULL
	WHERE UserNo = workingtime_removsetting.p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
