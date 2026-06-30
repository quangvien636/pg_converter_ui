-- ─── FUNCTION: convertoutctime ───────────────────────────────
DROP FUNCTION IF EXISTS public.convertoutctime(double precision, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.convertoutctime(
    timeoffset double precision,
    checktime timestamp without time zone
) RETURNS timestamp without time zone
AS $function$
DECLARE
    result timestamp without time zone;
BEGIN



	SET RESULT = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, CONVERT(DATETIME, CheckTime)), public."ChangeTimeOffset"(-TimeOffset)))

	RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
