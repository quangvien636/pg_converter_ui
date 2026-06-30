-- ─── FUNCTION: sns_updatemessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_updatemessage(character varying, integer);
CREATE OR REPLACE FUNCTION public.sns_updatemessage(
    message character varying,
    messageno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE SnsMessages SET Message=sns_updatemessage.message, RegDate=NOW() WHERE MessageNo=sns_updatemessage.messageno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
