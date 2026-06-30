-- ─── PROCEDURE→FUNCTION: crewchat_deletechatuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.crewchat_deletechatuser(bigint, integer);
CREATE OR REPLACE FUNCTION public.crewchat_deletechatuser(
    IN roomno bigint,
    IN userno integer
) RETURNS void
AS $function$
DECLARE
    lastedmsgno bigint;
    usercount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IsOne := (SELECT IsOne FROM CrewChat_Rooms WHERE RoomNo = crewchat_deletechatuser.roomno);
	RoomType := (SELECT RoomType FROM CrewChat_Rooms WHERE RoomNo = crewchat_deletechatuser.roomno);
	IF IsOne = FALSE THEN
		-- 그룹방 일 경우;
		DELETE FROM CrewChat_RoomUsers
		WHERE RoomNo = crewchat_deletechatuser.roomno AND UserNo = crewchat_deletechatuser.userno
		
		-- 자신과의 대화방 일 경우
		IF RoomType = 1 THEN
			-- 방삭제;
			DELETE FROM CrewChat_Rooms WHERE RoomNo = crewchat_deletechatuser.roomno
		END IF;
	END IF;
	ELSE
		-- 현재 방의 최신 메시지 번호

		LastedMsgNo := (SELECT /* TOP 1 */ MessageNo FROM CrewChat_Messages;
							WHERE RoomNo=crewchat_deletechatuser.roomno ORDER BY RegDate DESC)
		

		UserCount := (SELECT COUNT(*) FROM CrewChat_RoomUsers WHERE Closed=0);
		IF UserCount = 0 THEN
			-- 삭제 처리할까?
			-- 채팅 읽음 값을 모두 읽음으로 업데이트 합니다.;
			UPDATE CrewChat_CheckMessage SET IsRead = TRUE WHERE UserNo=crewchat_deletechatuser.userno
			AND RoomNo = crewchat_deletechatuser.roomno
		
			-- 1:1방 일 경우;
			UPDATE CrewChat_RoomUsers SET Closed = 1, StartMessageNo=LastedMsgNo + 1,
			RoomTitle = '', Notification = 1
			WHERE RoomNo = crewchat_deletechatuser.roomno AND UserNo = crewchat_deletechatuser.userno
		END IF;
		ELSE
			-- 채팅 읽음 값을 모두 읽음으로 업데이트 합니다.;
			UPDATE CrewChat_CheckMessage SET IsRead = TRUE WHERE UserNo=crewchat_deletechatuser.userno
			AND RoomNo = crewchat_deletechatuser.roomno
			
			-- 1:1방 일 경우;
			UPDATE CrewChat_RoomUsers SET Closed = 1, StartMessageNo=LastedMsgNo + 1,
			RoomTitle = '', Notification = 1
			WHERE RoomNo = crewchat_deletechatuser.roomno AND UserNo = crewchat_deletechatuser.userno
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
