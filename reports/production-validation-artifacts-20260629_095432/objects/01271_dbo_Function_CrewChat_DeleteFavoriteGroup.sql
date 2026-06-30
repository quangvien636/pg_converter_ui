-- ─── FUNCTION: crewchat_deletefavoritegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletefavoritegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_deletefavoritegroup(
    groupno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_FavoriteGroups
	WHERE GroupNo=crewchat_deletefavoritegroup.groupno AND UserNo=crewchat_deletefavoritegroup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
