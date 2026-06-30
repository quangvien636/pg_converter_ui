-- ─── FUNCTION: crewchat_deletefavoriteuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletefavoriteuser(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_deletefavoriteuser(
    groupno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_FavoriteUsers
	WHERE GroupNo=crewchat_deletefavoriteuser.groupno AND UserNo=crewchat_deletefavoriteuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
