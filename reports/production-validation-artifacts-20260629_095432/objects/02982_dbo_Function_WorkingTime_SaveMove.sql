-- ─── FUNCTION: workingtime_savemove ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_savemove(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savemove(
    p_uid integer,
    p_id integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	SET GroupId = workingtime_savemove.p_id
	WHERE UserNo = workingtime_savemove.p_uid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
