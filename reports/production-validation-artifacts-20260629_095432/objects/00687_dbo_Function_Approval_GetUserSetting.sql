-- ─── FUNCTION: approval_getusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.approval_getusersetting(
    userno integer
) RETURNS TABLE(
    userno text,
    signimage text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, SignImage
	FROM Approval_UserSettings
	WHERE UserNo = approval_getusersetting.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
