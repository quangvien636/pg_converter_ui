-- ─── FUNCTION: crewchat_getfavotitegroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getfavotitegroups(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitegroups(
    userno integer
) RETURNS TABLE(
    groupno text,
    userno text,
    name text,
    sortno text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT GroupNo, UserNo, Name, SortNo, ModDate FROM CrewChat_FavoriteGroups
	WHERE UserNo = crewchat_getfavotitegroups.userno ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
