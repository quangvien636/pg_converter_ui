-- ─── FUNCTION: changetimeoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.changetimeoffset(double precision);
CREATE OR REPLACE FUNCTION public.changetimeoffset(
    timeoffset double precision
) RETURNS character varying
AS $function$
DECLARE
    result character varying;
    shours character varying;
    sminutes character varying;
BEGIN








	IF Minutes > 10 OR Minutes <-10
	BEGIN
		SET SMinutes = ':' || CAST(REPLACE(Minutes,'-','')  AS varchar(2))
	END
	ELSE 
	BEGIN
		SET SMinutes = ':0' || CAST(REPLACE(Minutes,'-','')  AS varchar(2))
	END



	IF Hours >= 0 AND  Hours < 10
	BEGIN
		SET SHours = ' || 0' || CAST(Hours AS varchar(1))
	END
	ELSE IF Hours > 0 AND  Hours > 10
	BEGIN
		SET SHours = ' || ' || CAST(Hours AS varchar(2))
	END
	ELSE IF Hours < 0 AND  Hours > -10
	BEGIN
		SET SHours = '-0' || CAST(REPLACE(Hours,'-','') AS varchar(1))
	END
	ELSE IF Hours < 0 AND  Hours < -10
	BEGIN
		SET SHours = '-' || CAST(REPLACE(Hours,'-','') AS varchar(2))
	END

	SET RESULT = SHours || SMinutes

	RETURN RESULT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
