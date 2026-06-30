-- ─── FUNCTION: eappgetshortenname ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetshortenname();
CREATE OR REPLACE FUNCTION public.eappgetshortenname(
) RETURNS character varying
AS $function$
DECLARE
    name character varying;
BEGIN




	SELECT Name=EAPPUserEnv.ShortenName FROM public."EAPPUserEnv" WHERE EAPPUserEnv.UserID=UserID
	RETURN	(Name);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
