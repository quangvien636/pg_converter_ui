-- ─── FUNCTION: workingtime_setworkingtimemessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimemessage(integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimemessage(
    reguserno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkingTimeMessages(RegUserNo, RegDate, Message)
	VALUES(RegUserNo, NOW(), Message);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
