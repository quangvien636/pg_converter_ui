-- ─── FUNCTION: crewchat_insertfavoritegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertfavoritegroup(integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertfavoritegroup(
    userno integer
) RETURNS TABLE(
    groupno text,
    userno text,
    name text,
    sortno text,
    moddate text
)
AS $function$
DECLARE
    sortno integer;
    groupno integer;
BEGIN

	-- 추가될 그룹의 소트번호

	SET SortNo = (SELECT COALESCE(MAX(SortNo),0) FROM CrewChat_FavoriteGroups WHERE UserNo=crewchat_insertfavoritegroup.userno)
	SET SortNo = SortNo + 1
	
	INSERT INTO CrewChat_FavoriteGroups (UserNo, Name, SortNo, ModDate)
	VALUES (UserNo, Name, SortNo, NOW())
	

	SET GroupNo = lastval()
	IF GroupNo > 0 
	BEGIN
		-- 즐겨찾기 그룹 정보
		RETURN QUERY
		SELECT GroupNo, UserNo, Name, SortNo, ModDate FROM CrewChat_FavoriteGroups 
		WHERE GroupNo = GroupNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
