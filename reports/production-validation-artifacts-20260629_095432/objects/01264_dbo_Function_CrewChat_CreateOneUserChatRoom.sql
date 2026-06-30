-- ─── FUNCTION: crewchat_createoneuserchatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_createoneuserchatroom(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_createoneuserchatroom(
    userno integer,
    joinuserno integer
) RETURNS TABLE(
    roomno text,
    makeuserno text,
    moddate text,
    isone text,
    roomtitle text,
    userno text,
    newroom text
)
AS $function$
DECLARE
    roomno integer;
    isone boolean;
    isclosed boolean;
    roomtitle character varying;
BEGIN



	SET RoomNo = (SELECT public."CrewChat_GetOneUserChatRoom"(UserNo, JoinUserNo))
	
	IF RoomNo > 0 BEGIN

		-- 본인이 나간 방 일 경우 처리

		SET IsOne = (SELECT IsOne FROM CrewChat_Rooms WHERE RoomNo = RoomNo)

		IF IsOne = TRUE BEGIN
			-- 상대방이 나간 상태 일 때

			SET IsClosed = (SELECT Closed FROM CrewChat_RoomUsers WHERE RoomNo = RoomNo
							 AND UserNo = crewchat_createoneuserchatroom.userno)
							 
			IF IsClosed = TRUE BEGIN

				-- 나간 상태를 다시 돌려놓는다.;
				UPDATE CrewChat_RoomUsers SET Closed = 0
				WHERE RoomNo = RoomNo AND UserNo = crewchat_createoneuserchatroom.userno

			END
								 
		END

		SET RoomTitle = (SELECT RoomTitle FROM CrewChat_RoomUsers WHERE RoomNo = RoomNo AND UserNo=crewchat_createoneuserchatroom.userno)
		-- 기존 1:1 채팅방이 존재합니다.
		RETURN QUERY
		SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, RoomTitle AS RoomTitle, U.UserNo, FALSE AS NewRoom
		FROM CrewChat_Rooms R 
		INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
		WHERE R.RoomNo = RoomNo
				
	END

	ELSE BEGIN

		-- 기존방이 없습니다. 채팅방을 새로 생성합니다.;
		INSERT INTO CrewChat_Rooms (MakeUserNo, IsOne) VALUES (UserNo, 1)
		
		SET RoomNo = lastval()
		
		IF RoomNo > 0 BEGIN

			-- 방만드는 유저 추가;
			INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo) VALUES (RoomNo, UserNo)

			-- 상대방 추가;
			INSERT INTO CrewChat_RoomUsers (RoomNo, UserNo) VALUES (RoomNo, JoinUserNo)

		END
		
		-- 만들어진 방의 기본 정보를 보냅니다.
		RETURN QUERY
		SELECT R.RoomNo, R.MakeUserNo, R.ModDate, R.IsOne, U.RoomTitle, U.UserNo, TRUE AS NewRoom
		FROM CrewChat_Rooms R 
		INNER JOIN CrewChat_RoomUsers U ON U.RoomNo = R.RoomNo
		WHERE R.RoomNo = RoomNo

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
