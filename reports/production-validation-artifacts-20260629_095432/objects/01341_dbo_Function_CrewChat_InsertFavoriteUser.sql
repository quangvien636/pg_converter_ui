-- ─── FUNCTION: crewchat_insertfavoriteuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertfavoriteuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertfavoriteuser(
    groupno integer,
    reguserno integer,
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
DECLARE
    usercount integer;
    sortno integer;
    groupuserno integer;
BEGIN



	SET UserCount = (SELECT COUNT(*) FROM CrewChat_FavoriteUsers
	WHERE RegUserNo=crewchat_insertfavoriteuser.reguserno AND GroupNo = crewchat_insertfavoriteuser.groupno AND UserNo = crewchat_insertfavoriteuser.userno)

	IF UserCount = 0
	BEGIN

		SET SortNo = (SELECT COALESCE(MAX(SortNo),0) FROM CrewChat_FavoriteUsers 
		WHERE GroupNo = crewchat_insertfavoriteuser.groupno AND RegUserNo = crewchat_insertfavoriteuser.reguserno)
		SET SortNo = SortNo + 1
		
		INSERT INTO CrewChat_FavoriteUsers (RegUserNo, GroupNo, UserNo, SortNo, ModDate)
		VALUES (RegUserNo, GroupNo, UserNo, SortNo, NOW())
		

		SET GroupUserNo = lastval()
		IF GroupUserNo > 0 
		BEGIN
			-- 즐겨찾기 그룹 정보
			RETURN QUERY
			SELECT GroupUserNo, RegUserNo, GroupNo, UserNo, SortNo, ModDate 
			FROM CrewChat_FavoriteUsers 
			WHERE GroupUserNo = GroupUserNo
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
