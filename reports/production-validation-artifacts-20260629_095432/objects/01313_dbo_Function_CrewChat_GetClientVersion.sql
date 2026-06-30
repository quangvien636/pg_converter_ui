-- ─── FUNCTION: crewchat_getclientversion ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getclientversion(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getclientversion(
    userno integer
) RETURNS TABLE(
    pcversion text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT PCVersion FROM CrewChat_UserProfiles WHERE UserNo=crewchat_getclientversion.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
