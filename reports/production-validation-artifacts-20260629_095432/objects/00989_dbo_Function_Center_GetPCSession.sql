-- ─── FUNCTION: center_getpcsession ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getpcsession();
CREATE OR REPLACE FUNCTION public.center_getpcsession(
) RETURNS TABLE(
    sessionno text,
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SessionNo, UserNo
	FROM Center_PCSessions
	WHERE SessionID = SessionID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
