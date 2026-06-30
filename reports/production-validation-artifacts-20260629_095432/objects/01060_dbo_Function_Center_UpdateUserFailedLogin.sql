-- ─── FUNCTION: center_updateuserfailedlogin ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateuserfailedlogin(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.center_updateuserfailedlogin(
    userno integer,
    userid character varying,
    failedlogincount integer
) RETURNS void
AS $function$
BEGIN


	IF UserNo <> 0 BEGIN
		
		update Organization_Users set FailedLoginCount = center_updateuserfailedlogin.failedlogincount  WHERE UserNo = center_updateuserfailedlogin.userno
		
	END
	
	ELSE IF UserID <> '' BEGIN
		
		update Organization_Users set FailedLoginCount = center_updateuserfailedlogin.failedlogincount  WHERE UserID = center_updateuserfailedlogin.userid
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
