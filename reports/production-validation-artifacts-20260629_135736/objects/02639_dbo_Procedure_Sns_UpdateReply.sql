-- ─── PROCEDURE→FUNCTION: sns_updatereply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.sns_updatereply(character varying, integer);
CREATE OR REPLACE FUNCTION public.sns_updatereply(
    IN message character varying,
    IN replyno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE SnsReplys SET Message=sns_updatereply.message, RegDate=NOW() WHERE ReplyNo=sns_updatereply.replyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
