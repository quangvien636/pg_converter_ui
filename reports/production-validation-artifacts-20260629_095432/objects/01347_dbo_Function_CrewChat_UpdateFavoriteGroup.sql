-- ─── FUNCTION: crewchat_updatefavoritegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updatefavoritegroup(integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updatefavoritegroup(
    groupno integer,
    userno integer,
    name character varying,
    sortno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE CrewChat_FavoriteGroups SET Name=crewchat_updatefavoritegroup.name, SortNo=crewchat_updatefavoritegroup.sortno, ModDate=NOW()
	WHERE GroupNo=crewchat_updatefavoritegroup.groupno AND UserNo=crewchat_updatefavoritegroup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
