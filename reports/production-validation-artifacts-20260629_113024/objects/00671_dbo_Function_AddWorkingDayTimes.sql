-- ─── FUNCTION: addworkingdaytimes ───────────────────────────────
DROP FUNCTION IF EXISTS public.addworkingdaytimes(double precision, integer);
CREATE OR REPLACE FUNCTION public.addworkingdaytimes(
    timeoffset double precision,
    workingday integer
) RETURNS timestamp without time zone
AS $function$
DECLARE
    result timestamp without time zone;
BEGIN


	SET RESULT = CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, CONVERT(DATETIME, CONVERT(CHAR(8), WorkingDay, 112) + ' ' || CONVERT(CHAR(8), LEFT(CheckTime,2)+':' || SUBSTRING(CheckTime,3,2)+':' || RIGHT(CheckTime,2), 108)) ), public."ChangeTimeOffset"(TimeOffset)))

	RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
