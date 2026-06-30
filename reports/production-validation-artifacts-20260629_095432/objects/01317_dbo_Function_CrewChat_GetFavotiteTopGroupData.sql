-- ─── FUNCTION: crewchat_getfavotitetopgroupdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getfavotitetopgroupdata(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getfavotitetopgroupdata(
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
	SELECT GroupUserNo, RegUserNo, GroupNo, UserNo, SortNo, ModDate 
	FROM CrewChat_FavoriteUsers
	WHERE RegUserNo = crewchat_getfavotitetopgroupdata.userno AND GroupNo=0 ORDER BY GroupNo ASC, SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
