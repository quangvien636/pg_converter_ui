-- ─── FUNCTION: center_insertcrewchatnotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertcrewchatnotification(integer);
CREATE OR REPLACE FUNCTION public.center_insertcrewchatnotification(
    userno integer
) RETURNS void
AS $function$
BEGIN

	
	INSERT INTO Center_CrewChatNotification (UserNo,Message,RegDate)
	VALUES (UserNo,Message,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
