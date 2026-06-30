-- ─── PROCEDURE→FUNCTION: crewchat_insertfavoriteuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertfavoriteuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertfavoriteuser(
    IN groupno integer,
    IN reguserno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    usercount integer;
    sortno integer;
    groupuserno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	UserCount := (SELECT COUNT(*) FROM CrewChat_FavoriteUsers;
	WHERE RegUserNo=crewchat_insertfavoriteuser.reguserno AND GroupNo = crewchat_insertfavoriteuser.groupno AND UserNo = crewchat_insertfavoriteuser.userno)

	IF UserCount = 0 THEN

		SortNo := (SELECT COALESCE(MAX(SortNo),0) FROM CrewChat_FavoriteUsers;
		WHERE GroupNo = crewchat_insertfavoriteuser.groupno AND RegUserNo = crewchat_insertfavoriteuser.reguserno)
		SortNo := SortNo + 1;;
		INSERT INTO CrewChat_FavoriteUsers (RegUserNo, GroupNo, UserNo, SortNo, ModDate)
		VALUES (RegUserNo, GroupNo, UserNo, SortNo, NOW())
		

		GroupUserNo := lastval();
		IF GroupUserNo > 0 THEN
			-- 즐겨찾기 그룹 정보
			RETURN QUERY
			SELECT GroupUserNo, RegUserNo, GroupNo, UserNo, SortNo, ModDate 
			FROM CrewChat_FavoriteUsers 
			WHERE GroupUserNo = GroupUserNo
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
