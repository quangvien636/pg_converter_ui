-- ─── FUNCTION: wchat_insertchatmember ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_insertchatmember(integer);
CREATE OR REPLACE FUNCTION public.wchat_insertchatmember(
    chatno integer
) RETURNS TABLE(
    userno text
)
AS $function$
DECLARE
    memberno integer;
BEGIN


	

	SET MemberNo = 0
	
	INSERT INTO WCHATMembers (ChatNo,UserNo,IsAlarm,RegDate)	
	RETURN QUERY
	SELECT ChatNo,U.UserNo,1,NOW()
	FROM Organization_Users U
	WHERE U.UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(UserNos,';'))
	AND U.UserNo NOT IN (SELECT UserNo FROM WCHATMembers WHERE ChatNo = wchat_insertchatmember.chatno)
	AND U.Enabled = TRUE
	GROUP BY U.UserNo
	
	IF lastval() > 0
	BEGIN
		SET MemberNo = lastval()
	END
	
	RETURN QUERY
	SELECT MemberNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
