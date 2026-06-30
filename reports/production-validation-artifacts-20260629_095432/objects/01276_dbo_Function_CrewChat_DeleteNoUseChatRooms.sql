-- ─── FUNCTION: crewchat_deletenousechatrooms ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletenousechatrooms();
CREATE OR REPLACE FUNCTION public.crewchat_deletenousechatrooms(
) RETURNS void
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    tblroomno table
	(
		roomno bigint,
		msgdate datetime
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	-- 임시 테이블 생성

	-- 삭제 되는 일 수에 따른 방번호 테이블에 삽입;
	INSERT INTO TblRoomNo
	SELECT RoomNo, LastedMsgDate FROM CrewChat_Rooms 
	WHERE 
	LastedMsgDate <= DATEADD(DAY, -DIFFDAY, NOW()) 
	OR
	LastedMsgDate IS NULL
	ORDER BY ModDate ASC


	-- 채팅방 삭제;
	DELETE FROM CrewChat_Rooms WHERE RoomNo IN (SELECT RoomNo FROM TblRoomNo)

	-- 채팅메시지 삭제;
	DELETE FROM CrewChat_Messages WHERE RoomNo IN (SELECT RoomNo FROM TblRoomNo);
	DELETE FROM CrewChat_CheckMessage WHERE RoomNo IN (SELECT RoomNo FROM TblRoomNo)

	-- 채팅 참여인원 삭제;
	DELETE FROM CrewChat_RoomUsers WHERE RoomNo IN (SELECT RoomNo FROM TblRoomNo)

	-- 삭제된 방 정보 저장;
	INSERT INTO CrewChat_DeleteRooms
	SELECT RoomNo, MsgDate, NOW() FROM TblRoomNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
