-- ─── FUNCTION: workingtime_changepassword ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_changepassword(integer);
CREATE OR REPLACE FUNCTION public.workingtime_changepassword(
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	SET Password=PassNew
	WHERE UserNo=workingtime_changepassword.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
