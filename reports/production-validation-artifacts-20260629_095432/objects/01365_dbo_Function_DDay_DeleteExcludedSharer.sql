-- ─── FUNCTION: dday_deleteexcludedsharer ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deleteexcludedsharer(bigint);
CREATE OR REPLACE FUNCTION public.dday_deleteexcludedsharer(
    datano bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_ExcludedSharers
	WHERE DataNo = dday_deleteexcludedsharer.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
