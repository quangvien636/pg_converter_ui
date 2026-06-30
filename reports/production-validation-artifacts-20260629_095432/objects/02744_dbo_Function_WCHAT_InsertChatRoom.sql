-- ─── FUNCTION: wchat_insertchatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_insertchatroom(integer);
CREATE OR REPLACE FUNCTION public.wchat_insertchatroom(
    userno integer
) RETURNS TABLE(
    value text
)
AS $function$
DECLARE
    chatno integer;
BEGIN


	
	-- 방을 개설한다.;
	INSERT INTO WCHATRooms (MakeUserNo,RegDate) VALUES
	(UserNo, NOW())	
	

	SET ChatNo = lastval()
	
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
