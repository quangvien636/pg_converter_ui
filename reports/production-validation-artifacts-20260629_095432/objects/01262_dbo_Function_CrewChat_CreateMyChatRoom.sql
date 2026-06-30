-- ─── FUNCTION: crewchat_createmychatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_createmychatroom(integer);
CREATE OR REPLACE FUNCTION public.crewchat_createmychatroom(
    userno integer
) RETURNS TABLE(
    roomno text,
    makeuserno text,
    moddate text,
    isone text,
    roomtitle text,
    userno text,
    roomtype text
)
AS $function$
DECLARE
    roomno bigint;
BEGIN

	
	-- 기존방이 존재하는지 여부 체크

	SET RoomNO = (SELECT RoomNo FROM CrewChat_Rooms WHERE RoomType=1 AND MakeUserNo=crewchat_createmychatroom.userno)
	
	IF RoomNo > 0
	BEGIN
		-- 기존 채팅방이 존재합니다.
		RETURN QUERY
		SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle, U.UserNo, RoomType
		FROM CrewChat_Rooms R 
		INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
		WHERE R.RoomNo = RoomNo
				
	END
	ELSE
	BEGIN
		-- 기존방이 없습니다. 채팅방을 새로 생성합니다.;
		INSERT INTO CrewChat_Rooms (MakeUserNo, IsOne, RoomType)
		VALUES (UserNo, 0, 1)
		
		SET RoomNo = lastval()
		
		IF RoomNo > 0
		BEGIN
			-- 방만드는 유저 추가;
			INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo)
			VALUES (RoomNo, UserNo)
		END
		
		-- 만들어진 방의 기본 정보를 보냅니다.
		RETURN QUERY
		SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle, U.UserNo, R.RoomType
		FROM CrewChat_Rooms R 
		INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
		WHERE R.RoomNo = RoomNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
