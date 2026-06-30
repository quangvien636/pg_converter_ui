-- ─── FUNCTION: crewchat_getalluserprofile ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getalluserprofile();
CREATE OR REPLACE FUNCTION public.crewchat_getalluserprofile(
) RETURNS TABLE(
    userno text,
    statemessage text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT UserNo, StateMessage FROM CrewChat_UserProfiles
	ORDER BY UserNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
