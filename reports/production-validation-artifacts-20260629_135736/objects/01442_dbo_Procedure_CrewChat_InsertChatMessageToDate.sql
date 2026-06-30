-- ─── PROCEDURE→FUNCTION: crewchat_insertchatmessagetodate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertchatmessagetodate(bigint, integer, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.crewchat_insertchatmessagetodate(
    IN roomno bigint,
    IN userno integer,
    IN message character varying,
    IN type integer,
    IN regdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    messageno bigint;
    isone boolean;
    isclosed boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO CrewChat_Messages (RoomNo, UserNo, Message, Type, AttachNo, RegDate)
	VALUES (RoomNo, UserNo, Message, Type, 0, RegDate)
	
	MessageNo := lastval();
	-- 1:1 채팅방 일 때

	IsOne := (SELECT IsOne FROM CrewChat_Rooms WITH (UPDLOCK) WHERE RoomNo = crewchat_insertchatmessagetodate.roomno);
	IF IsOne = TRUE THEN
		-- 상대방이 나간 상태 일 때

		IsClosed := (SELECT Closed FROM CrewChat_RoomUsers WITH (UPDLOCK) WHERE RoomNo = crewchat_insertchatmessagetodate.roomno;
						 AND UserNo != crewchat_insertchatmessagetodate.userno)
						 
		IF IsClosed = TRUE THEN
			-- 나간 상태를 다시 돌려놓는다.;
			UPDATE CrewChat_RoomUsers WITH (UPDLOCK) SET Closed = 0, StartMessageNo=MessageNo 
			WHERE RoomNo = crewchat_insertchatmessagetodate.roomno AND UserNo != crewchat_insertchatmessagetodate.userno
		END IF;
	END IF;
	
	RETURN QUERY
	SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
	(SELECT COUNT(*) FROM CrewChat_CheckMessage C WITH (UPDLOCK)
	WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnreadCount,
	(SELECT U.Name FROM Organization_Users U WITH (UPDLOCK) WHERE U.UserNo = M.UserNo) AS UserName
	FROM CrewChat_Messages M WITH (UPDLOCK)
	WHERE M.MessageNo = MessageNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
