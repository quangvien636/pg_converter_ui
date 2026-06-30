-- ─── FUNCTION: center_getuserfailedlogincount ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getuserfailedlogincount(integer);
CREATE OR REPLACE FUNCTION public.center_getuserfailedlogincount(
    userno integer
) RETURNS TABLE(
    failedlogincount text
)
AS $function$
BEGIN


	IF UserNo <> 0 BEGIN
		
		RETURN QUERY
		SELECT FailedLoginCount
		FROM Organization_Users WHERE UserNo = center_getuserfailedlogincount.userno
		
	END
	
	ELSE IF UserID <> '' BEGIN
		
		RETURN QUERY
		SELECT FailedLoginCount
		FROM Organization_Users WHERE UserID = UserID
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
