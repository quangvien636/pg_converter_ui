-- ─── FUNCTION: crewchat_getchatroomuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getchatroomuserlist(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomuserlist(
    roomno bigint
) RETURNS TABLE(
    unreadcount text
)
AS $function$
BEGIN

	-- 해당 채팅방의 유저 리스트
	RETURN QUERY
	SELECT U.UserNo, 
	O.UserID,
	COALESCE(A.DeviceID,'') AS Android, 
	COALESCE(I.DeviceID,'') AS iOS,
	COALESCE(A.NotifyEnable,1) AS Android_NotifyEnable,
	COALESCE(A.NotifySound,1) AS Android_NotifySound,
	COALESCE(A.NotifyVibrate,1) AS Android_NotifyVibrate,
	COALESCE(A.NotifyUseTime,0) AS Android_NotifyUseTime,
	COALESCE(A.NotifyStartTime,'08:00') AS Android_NotifyStartTime,
	COALESCE(A.NotifyEndTime,'18:00') AS Android_NotifyEndTime,
	COALESCE(A.NotifyConfirmOnline,1) AS Android_NotifyConfirmOnline,
	COALESCE(A.TimeZoneOffset,540) AS Android_TimeZoneOffset,
	
	COALESCE(I.NotifyEnable,1) AS iOS_NotifyEnable,
	COALESCE(I.NotifyUseTime,0) AS iOS_NotifyUseTime,
	COALESCE(I.NotifyStartTime,'08:00') AS iOS_NotifyStartTime,
	COALESCE(I.NotifyEndTime,'18:00') AS iOS_NotifyEndTime,
	COALESCE(I.NotifyConfirmOnline,1) AS iOS_NotifyConfirmOnline,
	COALESCE(I.TimeZoneOffset,540) AS iOS_TimeZoneOffset,
	U.Notification,
	(SELECT COUNT(CheckNo)AS UnReadCount FROM CrewChat_CheckMessage C
	INNER JOIN CrewChat_RoomUsers R ON 
	R.UserNo = U.UserNo AND R.Closed = 0 AND R.RoomNo = C.RoomNo
	AND R.StartMessageNo <= C.MessageNo
	WHERE C.UserNo = U.UserNo AND C.IsRead = FALSE AND C.RoomNo=crewchat_getchatroomuserlist.roomno) AS UnreadCount,
	(SELECT COUNT(*) AS UnReadCount FROM CrewChat_CheckMessage C
	INNER JOIN CrewChat_RoomUsers R ON 
	R.UserNo = U.UserNo AND R.Closed = 0 AND R.RoomNo = C.RoomNo
	AND R.StartMessageNo <= C.MessageNo
	WHERE C.UserNo = U.UserNo AND C.IsRead = FALSE) AS TotalUnreadCount
	FROM CrewChat_RoomUsers U WITH (UPDLOCK)
	LEFT JOIN CrewChat_AndroidDevices A ON A.UserNo = U.UserNo
	LEFT JOIN CrewChat_IOSDevices I ON I.UserNo = U.UserNo
	INNER JOIN Organization_Users O ON O.UserNo = U.UserNo
	WHERE U.RoomNo = crewchat_getchatroomuserlist.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
