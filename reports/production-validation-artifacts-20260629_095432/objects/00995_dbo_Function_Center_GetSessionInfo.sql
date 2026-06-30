-- ─── FUNCTION: center_getsessioninfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getsessioninfo(integer, character varying);
CREATE OR REPLACE FUNCTION public.center_getsessioninfo(
    userno integer,
    userid character varying
) RETURNS TABLE(
    userno text,
    userid text,
    sessionid text
)
AS $function$
BEGIN


	IF UserNo != 0 BEGIN
	
		RETURN QUERY
		SELECT UserNo, UserID, SessionID
		FROM Center_Sessions WHERE UserNo = center_getsessioninfo.userno
	
	END
	
	ELSE IF UserID != '' BEGIN
	
		RETURN QUERY
		SELECT UserNo, UserID, SessionID
		FROM Center_Sessions WHERE UserID = center_getsessioninfo.userid
	
	END
	
	ELSE IF SessionID != '' BEGIN
	
		RETURN QUERY
		SELECT UserNo, UserID, SessionID
		FROM Center_Sessions WHERE SessionID = SessionID
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
