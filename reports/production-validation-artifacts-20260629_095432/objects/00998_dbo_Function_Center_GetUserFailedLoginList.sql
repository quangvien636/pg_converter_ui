-- ─── FUNCTION: center_getuserfailedloginlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getuserfailedloginlist();
CREATE OR REPLACE FUNCTION public.center_getuserfailedloginlist(
) RETURNS TABLE(
    value text
)
AS $function$
BEGIN


	RETURN QUERY
	select UserNo,UserID,Name,FailedLoginCount from Organization_Users
	where FailedLoginCount >= (select Value from Center_Configuration where key = 'KEY_Use_LOGIN_PasswordMust_Cnt');
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
