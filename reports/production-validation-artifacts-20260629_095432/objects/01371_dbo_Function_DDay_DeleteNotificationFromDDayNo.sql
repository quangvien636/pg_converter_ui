-- ─── FUNCTION: dday_deletenotificationfromddayno ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletenotificationfromddayno(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletenotificationfromddayno(
    ddayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Notifications WHERE DayNo = dday_deletenotificationfromddayno.ddayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
