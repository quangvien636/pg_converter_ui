-- ─── FUNCTION: center_getauthuserinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getauthuserinfo(integer);
CREATE OR REPLACE FUNCTION public.center_getauthuserinfo(
    userno integer
) RETURNS TABLE(
    userno text,
    userid text,
    password text,
    passwordchangedate text,
    enabled text
)
AS $function$
BEGIN


	IF UserNo <> 0 BEGIN
		
		RETURN QUERY
		SELECT UserNo, UserID, Password, PasswordChangeDate, Enabled
		FROM Organization_Users WHERE UserNo = center_getauthuserinfo.userno
		
	END
	
	ELSE IF UserID <> '' BEGIN
		
		RETURN QUERY
		SELECT UserNo, UserID, Password, PasswordChangeDate, Enabled
		FROM Organization_Users WHERE UserID = UserID
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
