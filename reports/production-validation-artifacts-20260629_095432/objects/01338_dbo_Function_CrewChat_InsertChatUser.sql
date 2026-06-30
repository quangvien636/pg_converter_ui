-- ─── FUNCTION: crewchat_insertchatuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertchatuser(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertchatuser(
    roomno bigint,
    userno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    usercount integer;
    startmessageno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET UserCount = (SELECT COUNT(*) FROM CrewChat_RoomUsers WHERE UserNo=crewchat_insertchatuser.userno AND RoomNo=crewchat_insertchatuser.roomno)
	
	-- 중복된 유저가 없을 경우만 추가해줍니다.
	IF UserCount = 0 BEGIN


		SET StartMessageNo = (SELECT /* TOP 1 */ COALESCE(MessageNo,0) FROM CrewChat_Messages WHERE RoomNo = crewchat_insertchatuser.roomno ORDER BY MessageNo DESC)
		
		IF StartMessageNo > 0 BEGIN

			SET StartMessageNo = StartMessageNo + 1

		END

		ELSE BEGIN

			SET StartMessageNo = 0

		END
		
		INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo, StartMessageNo, ModDate)
		VALUES (RoomNo, UserNo, StartMessageNo, NOW())

		RETURN QUERY
		SELECT CONVERT(BIGINT, 1)

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT CONVERT(BIGINT, 0)

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
