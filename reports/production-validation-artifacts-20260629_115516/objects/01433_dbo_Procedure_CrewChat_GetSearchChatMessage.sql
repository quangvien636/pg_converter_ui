-- ─── PROCEDURE→FUNCTION: crewchat_getsearchchatmessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.crewchat_getsearchchatmessage(bigint, integer, character varying, bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getsearchchatmessage(
    IN roomno bigint,
    IN userno integer,
    IN searchtext character varying,
    IN msgno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    startmsgno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	StartMsgNo := (SELECT StartMessageNo FROM CrewChat_RoomUsers;
	WHERE RoomNo = crewchat_getsearchchatmessage.roomno AND UserNo = crewchat_getsearchchatmessage.userno)
	
	IF MsgNo = 0 THEN
		RETURN QUERY
		SELECT /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, M.Message, 
		M.Type, M.AttachNo, M.RegDate,
		(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
		WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
		FROM CrewChat_Messages M
		WHERE M.RoomNo = crewchat_getsearchchatmessage.roomno AND M.MessageNo >= StartMsgNo 
		AND (Type=0 OR Type=3) AND MessageNo > crewchat_getsearchchatmessage.msgno
		AND Message ILIKE '%' || SearchText || '%' 
		ORDER BY M.MessageNo DESC
	END IF;
	ELSE
		RETURN QUERY
		SELECT /* TOP 20 */ M.MessageNo, M.RoomNo, M.UserNo, M.Message, 
		M.Type, M.AttachNo, M.RegDate,
		(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
		WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
		FROM CrewChat_Messages M
		WHERE M.RoomNo = crewchat_getsearchchatmessage.roomno AND M.MessageNo >= StartMsgNo 
		AND (Type=0 OR Type=3) AND MessageNo < crewchat_getsearchchatmessage.msgno
		AND Message ILIKE '%' || SearchText || '%' 
		ORDER BY M.MessageNo DESC
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
