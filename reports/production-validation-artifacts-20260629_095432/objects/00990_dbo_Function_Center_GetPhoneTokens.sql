-- ─── FUNCTION: center_getphonetokens ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getphonetokens();
CREATE OR REPLACE FUNCTION public.center_getphonetokens(
) RETURNS TABLE(
    sessionid text,
    domain text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SessionID, Domain
		FROM Center_PhoneTokens 
		WHERE PhoneToken = PhoneToken;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
