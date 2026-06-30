-- ─── FUNCTION: crewchat_getuserprofile ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getuserprofile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getuserprofile(
    userno integer
) RETURNS TABLE(
    statemessage text,
    statetype text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT StateMessage, StateType FROM CrewChat_UserProfiles
	WHERE UserNo = crewchat_getuserprofile.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
