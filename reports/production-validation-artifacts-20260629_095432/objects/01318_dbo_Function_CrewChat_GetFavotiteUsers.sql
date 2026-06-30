-- ─── FUNCTION: crewchat_getfavotiteusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getfavotiteusers(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotiteusers(
    groupno integer
) RETURNS TABLE(
    groupno text,
    userno text,
    sortno text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT GroupNo, UserNo, SortNo, ModDate FROM CrewChat_FavoriteUsers
	WHERE GroupNo = crewchat_getfavotiteusers.groupno ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
