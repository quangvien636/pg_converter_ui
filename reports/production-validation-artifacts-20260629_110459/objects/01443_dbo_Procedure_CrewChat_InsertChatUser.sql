-- ─── PROCEDURE→FUNCTION: crewchat_insertchatuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.crewchat_insertchatuser(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertchatuser(
    IN roomno bigint,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    usercount integer;
    startmessageno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	UserCount := (SELECT COUNT(*) FROM CrewChat_RoomUsers WHERE UserNo=crewchat_insertchatuser.userno AND RoomNo=crewchat_insertchatuser.roomno);
	-- 중복된 유저가 없을 경우만 추가해줍니다.
	IF UserCount = 0 THEN


		StartMessageNo := (SELECT /* TOP 1 */ COALESCE(MessageNo,0) FROM CrewChat_Messages WHERE RoomNo = crewchat_insertchatuser.roomno ORDER BY MessageNo DESC);
		IF StartMessageNo > 0 THEN

			StartMessageNo := StartMessageNo + 1;
		END IF;

		ELSE BEGIN

			StartMessageNo := 0;
		END IF;
		
		INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo, StartMessageNo, ModDate)
		VALUES (RoomNo, UserNo, StartMessageNo, NOW())

		RETURN QUERY
		SELECT CONVERT(BIGINT, 1)

	END;

	ELSE BEGIN

		RETURN QUERY
		SELECT CONVERT(BIGINT, 0)

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
