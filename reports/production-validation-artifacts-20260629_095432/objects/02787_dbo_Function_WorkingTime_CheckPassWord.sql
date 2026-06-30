-- ─── FUNCTION: workingtime_checkpassword ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_checkpassword(integer);
CREATE OR REPLACE FUNCTION public.workingtime_checkpassword(
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(*) 
	FROM Organization_Users
	WHERE UserNo=workingtime_checkpassword.userno AND Password=PassOld;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
