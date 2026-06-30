-- ─── FUNCTION: workingtime_setdevicesid2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setdevicesid2(integer, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_setdevicesid2(
    p_uno integer,
    p_vs character varying
) RETURNS TABLE(
    1 text
)
AS $function$
BEGIN

		UPDATE WorkingTime_AllowDevices
				SET verson = workingtime_setdevicesid2.p_vs,
				SessionId = p_sid
				WHERE UserNo = workingtime_setdevicesid2.p_uno 

	RETURN QUERY
	select 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
