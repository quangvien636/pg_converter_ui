-- ─── FUNCTION: crewchat_getfavotitegroupanddata ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getfavotitegroupanddata(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitegroupanddata(
    userno integer
) RETURNS TABLE(
    groupuserno text,
    reguserno text,
    groupno text,
    userno text,
    sortno text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT GroupNo, UserNo, Name, SortNo, ModDate 
	FROM CrewChat_FavoriteGroups
	WHERE UserNo = crewchat_getfavotitegroupanddata.userno ORDER BY SortNo ASC
	
	RETURN QUERY
	SELECT GroupUserNo, RegUserNo, GroupNo, UserNo, SortNo, ModDate 
	FROM CrewChat_FavoriteUsers
	WHERE RegUserNo = crewchat_getfavotitegroupanddata.userno AND GroupNo > 0 ORDER BY GroupNo ASC, SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
