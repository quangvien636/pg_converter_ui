-- ─── FUNCTION: workingtime_getworkingtimemessages ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimemessages();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimemessages(
) RETURNS TABLE(
    messageno text,
    userno text,
    username text,
    userphoto text,
    regdate text,
    message text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT W.MessageNo, W.RegUserNo AS UserNo, U.Name AS UserName, U.UserPhoto, W.RegDate, W.Message
	FROM WorkingTimeMessages W
	INNER JOIN Users U ON U.UserNo = W.RegUserNo
	ORDER BY MessageNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
