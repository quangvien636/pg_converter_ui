-- ─── FUNCTION: notice_getpermissionforuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getpermissionforuser(integer);
CREATE OR REPLACE FUNCTION public.notice_getpermissionforuser(
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COALESCE((SELECT Permission FROM Notice_UserPermission WHERE UserNo = notice_getpermissionforuser.userno),0) AS Permission;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
