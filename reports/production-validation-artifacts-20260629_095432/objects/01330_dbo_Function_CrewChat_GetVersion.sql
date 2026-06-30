-- ─── FUNCTION: crewchat_getversion ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getversion();
CREATE OR REPLACE FUNCTION public.crewchat_getversion(
) RETURNS TABLE(
    iosversion text
)
AS $function$
BEGIN

	IF ClientType = 'PC'
	BEGIN
		RETURN QUERY
		SELECT PCVersion FROM CrewChat_Versions
	END
	ELSE IF ClientType = 'Android'
	BEGIN
		RETURN QUERY
		SELECT AndroidVersion FROM CrewChat_Versions
	END
	ELSE IF ClientType = 'iOS'
	BEGIN
		RETURN QUERY
		SELECT iOSVersion FROM CrewChat_Versions
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
