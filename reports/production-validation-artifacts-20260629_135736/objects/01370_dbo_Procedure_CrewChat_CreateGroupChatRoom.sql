-- ─── PROCEDURE→FUNCTION: crewchat_creategroupchatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_creategroupchatroom(integer, character varying);
CREATE OR REPLACE FUNCTION public.crewchat_creategroupchatroom(
    IN userno integer,
    IN joinusernos character varying
) RETURNS SETOF record
AS $function$
DECLARE
    roomno bigint;
    arrayusercount integer;
    arrayusers table
	(   
		pos int,
		value nvarchar(2000);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 생성방 번호


	-- 유저 테이블

	) 
	
	-- 유저 테이블 정보 SET;
	INSERT INTO ArrayUsers
	RETURN QUERY
	SELECT POSITION,VALUE FROM public."UF_TEXT_SPLIT" (JoinUserNos, ',')
	
	ArrayUserCount := (SELECT COUNT(*) FROM ArrayUsers);
	IF ArrayUserCount >= 1 THEN
	-- 그룹방 입니다.
	-- 방생성;
		INSERT INTO CrewChat_Rooms (MakeUserNo, IsOne)
		VALUES (UserNo, 0)
			
		RoomNo := lastval();
		IF RoomNo > 0 THEN
		-- 생성방에 유저 추가
		-- 방만드는 유저 추가;
			INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo, StartMessageNo, RoomTitle)
			VALUES (RoomNo, UserNo, 0, RoomTitle)
		-- 초대 유저 추가	;
			INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo, StartMessageNo, RoomTitle)
			RETURN QUERY
			SELECT RoomNo, CONVERT(INT,VALUE), 0, RoomTitle FROM ArrayUsers
		
		-- 만들어진 방의 기본 정보를 보냅니다.
			RETURN QUERY
			SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, 
			U.RoomTitle, U.UserNo, R.GroupType
			FROM CrewChat_Rooms R 
			INNER JOIn CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
			WHERE R.RoomNo = RoomNo
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
