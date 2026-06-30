-- ─── PROCEDURE→FUNCTION: crewchat_getchatroomuserlistunreadcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getchatroomuserlistunreadcount(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomuserlistunreadcount(
    IN roomno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
	(SELECT COUNT(CheckNo) AS UnReadCount FROM CrewChat_CheckMessage C
	INNER JOIN CrewChat_RoomUsers R ON 
	R.UserNo = U.UserNo AND R.Closed = 0 AND R.RoomNo = C.RoomNo
	AND R.StartMessageNo <= C.MessageNo
	WHERE C.UserNo = U.UserNo AND C.IsRead = FALSE) AS UnreadCount
	
	FROM CrewChat_RoomUsers U
	LEFT JOIN CrewChat_AndroidDevices A ON A.UserNo = U.UserNo
	LEFT JOIN CrewChat_IOSDevices I ON I.UserNo = U.UserNo
	LEFT JOIN Organization_Users O ON O.UserNo = U.UserNo
	WHERE RoomNo = crewchat_getchatroomuserlistunreadcount.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
