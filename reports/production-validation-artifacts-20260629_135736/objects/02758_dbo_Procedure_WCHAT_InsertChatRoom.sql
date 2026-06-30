-- ─── PROCEDURE→FUNCTION: wchat_insertchatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_insertchatroom(integer);
CREATE OR REPLACE FUNCTION public.wchat_insertchatroom(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    chatno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	-- 방을 개설한다.;
	INSERT INTO WCHATRooms (MakeUserNo,RegDate) VALUES
	(UserNo, NOW())	
	

	ChatNo := lastval();
	-- 방장을 맴버테이블에 추가한다.;
	INSERT INTO WCHATMembers (ChatNo,UserNo,IsAlarm,RegDate) VALUES
	(ChatNo, UserNo, 1, NOW())

	-- 맴버들을 추가한다.;
	INSERT INTO WCHATMembers (ChatNo,UserNo,IsAlarm,RegDate)	
	RETURN QUERY
	SELECT ChatNo,U.UserNo,1,NOW()
	FROM Organization_Users U
	WHERE U.UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(UserNos,';'))
	AND U.UserNo != wchat_insertchatroom.userno
	AND U.Enabled = TRUE
	GROUP BY U.UserNo
	
	RETURN QUERY
	SELECT ChatNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
