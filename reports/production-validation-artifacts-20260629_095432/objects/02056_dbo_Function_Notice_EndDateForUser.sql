-- ─── FUNCTION: notice_enddateforuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_enddateforuser(integer);
CREATE OR REPLACE FUNCTION public.notice_enddateforuser(
    p_uno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COALESCE((SELECT /* TOP 1 */ ViewEndDate FROM Notice_UserPermission WHERE UserNo = notice_enddateforuser.p_uno),1) AS ViewEndDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
