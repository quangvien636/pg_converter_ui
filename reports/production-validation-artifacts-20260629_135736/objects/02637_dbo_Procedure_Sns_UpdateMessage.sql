-- ─── PROCEDURE→FUNCTION: sns_updatemessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.sns_updatemessage(character varying, integer);
CREATE OR REPLACE FUNCTION public.sns_updatemessage(
    IN message character varying,
    IN messageno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE SnsMessages SET Message=sns_updatemessage.message, RegDate=NOW() WHERE MessageNo=sns_updatemessage.messageno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
