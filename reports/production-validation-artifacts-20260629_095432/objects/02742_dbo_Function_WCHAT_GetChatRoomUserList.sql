-- ─── FUNCTION: wchat_getchatroomuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_getchatroomuserlist(integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomuserlist(
    chatno integer
) RETURNS TABLE(
    chatno text,
    memberno text,
    userno text,
    isalarm text,
    regdate text
)
AS $function$
BEGIN


	
	RETURN QUERY
	SELECT M.ChatNo, M.MemberNo, M.UserNo, M.IsAlarm, M.RegDate FROM WCHATMembers M
	WHERE M.ChatNo = wchat_getchatroomuserlist.chatno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
