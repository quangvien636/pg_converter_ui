-- ─── FUNCTION: convertworkingtimeworktotime ───────────────────────────────
DROP FUNCTION IF EXISTS public.convertworkingtimeworktotime(double precision);
CREATE OR REPLACE FUNCTION public.convertworkingtimeworktotime(
    tworkingtimework double precision
) RETURNS character varying
AS $function$
DECLARE
    result character varying;
    mytime timestamp without time zone;
BEGIN

		-- chuyen float sang datetime


	set myTime = convert(DATETIME, tWorkingTimeWork)

	-- Shows 1900-01-01 19:47:16.123
	SET RESULT = convert(varchar(8),mytime,108)
	-- Shows 19:47:16

	RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
