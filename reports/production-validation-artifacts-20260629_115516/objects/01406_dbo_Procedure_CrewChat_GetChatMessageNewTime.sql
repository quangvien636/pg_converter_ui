-- ─── PROCEDURE→FUNCTION: crewchat_getchatmessagenewtime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getchatmessagenewtime(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatmessagenewtime(
    IN roomno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    msgtable table;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	(
		MessageNo BIGINT,
		RoomNo BIGINT,
		UserNo INT,
		Message text,
		Type INT,
		AttachNo INT,
		RegDate DateTime,
		UnReadCount INT
	)
	
	INSERT INTO MsgTable
		RETURN QUERY
		SELECT * FROM (
			SELECT M.MessageNo, M.RoomNo, M.UserNo, M.Message, M.Type, M.AttachNo, M.RegDate,
			(SELECT COUNT(*) FROM CrewChat_CheckMessage C 
			WHERE C.RoomNo=M.RoomNo AND C.IsRead = FALSE AND C.MessageNo = M.MessageNo) AS UnReadCount
			FROM CrewChat_Messages M
			WHERE M.RoomNo = crewchat_getchatmessagenewtime.roomno
			AND M.RegDate > BaseDate

		) T
		ORDER BY T.RegDate ASC
		
		-- 최종 결과
	RETURN QUERY
	SELECT MessageNo,RoomNo,UserNo,Message,Type,AttachNo,RegDate,UnReadCount
	FROM MsgTable ORDER BY RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
