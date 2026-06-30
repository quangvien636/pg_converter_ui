-- ─── FUNCTION: crewchat_deletechatuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletechatuser(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_deletechatuser(
    roomno bigint,
    userno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    lastedmsgno bigint;
    usercount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SET IsOne = (SELECT IsOne FROM CrewChat_Rooms WHERE RoomNo = crewchat_deletechatuser.roomno)
	SET RoomType = (SELECT RoomType FROM CrewChat_Rooms WHERE RoomNo = crewchat_deletechatuser.roomno)
	
	IF IsOne = FALSE
	BEGIN
		-- 그룹방 일 경우;
		DELETE FROM CrewChat_RoomUsers
		WHERE RoomNo = crewchat_deletechatuser.roomno AND UserNo = crewchat_deletechatuser.userno
		
		-- 자신과의 대화방 일 경우
		IF RoomType = 1
		BEGIN
			-- 방삭제;
			DELETE FROM CrewChat_Rooms WHERE RoomNo = crewchat_deletechatuser.roomno
		END
	END
	ELSE
	BEGIN
		-- 현재 방의 최신 메시지 번호

		SET LastedMsgNo = (SELECT /* TOP 1 */ MessageNo FROM CrewChat_Messages 
							WHERE RoomNo=crewchat_deletechatuser.roomno ORDER BY RegDate DESC)
		

		SET UserCount = (SELECT COUNT(*) FROM CrewChat_RoomUsers WHERE Closed=0)
		IF UserCount = 0
		BEGIN
			-- 삭제 처리할까?
			-- 채팅 읽음 값을 모두 읽음으로 업데이트 합니다.;
			UPDATE CrewChat_CheckMessage SET IsRead = TRUE WHERE UserNo=crewchat_deletechatuser.userno
			AND RoomNo = crewchat_deletechatuser.roomno
		
			-- 1:1방 일 경우;
			UPDATE CrewChat_RoomUsers SET Closed = 1, StartMessageNo=LastedMsgNo + 1,
			RoomTitle = '', Notification = 1
			WHERE RoomNo = crewchat_deletechatuser.roomno AND UserNo = crewchat_deletechatuser.userno
		END
		ELSE
		BEGIN
			-- 채팅 읽음 값을 모두 읽음으로 업데이트 합니다.;
			UPDATE CrewChat_CheckMessage SET IsRead = TRUE WHERE UserNo=crewchat_deletechatuser.userno
			AND RoomNo = crewchat_deletechatuser.roomno
			
			-- 1:1방 일 경우;
			UPDATE CrewChat_RoomUsers SET Closed = 1, StartMessageNo=LastedMsgNo + 1,
			RoomTitle = '', Notification = 1
			WHERE RoomNo = crewchat_deletechatuser.roomno AND UserNo = crewchat_deletechatuser.userno
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
