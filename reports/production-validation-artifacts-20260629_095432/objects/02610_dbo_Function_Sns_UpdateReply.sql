-- ─── FUNCTION: sns_updatereply ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_updatereply(character varying, integer);
CREATE OR REPLACE FUNCTION public.sns_updatereply(
    message character varying,
    replyno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE SnsReplys SET Message=sns_updatereply.message, RegDate=NOW() WHERE ReplyNo=sns_updatereply.replyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
