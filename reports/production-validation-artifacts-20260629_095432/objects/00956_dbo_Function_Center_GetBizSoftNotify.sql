-- ─── FUNCTION: center_getbizsoftnotify ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getbizsoftnotify();
CREATE OR REPLACE FUNCTION public.center_getbizsoftnotify(
) RETURNS TABLE(
    notifyno text,
    notifytype text,
    notifytypeno text,
    notifytitle text,
    notifydate text,
    notifyuserno text,
    notifystatus text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		NotifyNo,
		NotifyType,
		NotifyTypeNo,
		NotifyTitle,
		NotifyDate,
		NotifyUserNo,
		NotifyStatus
	FROM BizSoftNotify;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
