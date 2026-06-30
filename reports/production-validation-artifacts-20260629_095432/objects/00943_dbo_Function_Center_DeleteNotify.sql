-- ─── FUNCTION: center_deletenotify ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletenotify(integer);
CREATE OR REPLACE FUNCTION public.center_deletenotify(
    notifyno integer
) RETURNS void
AS $function$
BEGIN

	DELETE
	FROM BizSoftNotify
	WHERE NotifyNo = center_deletenotify.notifyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
