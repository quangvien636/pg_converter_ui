-- ─── FUNCTION: workingtime_settingsdefault ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_settingsdefault();
CREATE OR REPLACE FUNCTION public.workingtime_settingsdefault(
) RETURNS TABLE(
    col1 text,
    userid text,
    name text,
    name_en text
)
AS $function$
BEGIN


   RETURN QUERY
   select S.*,U.UserId, U.Name, U.Name_EN
   
    from WorkingTime_Settings S
	LEFT JOIN Organization_Users U
	ON S.RegUserNo = U.USERNO;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
