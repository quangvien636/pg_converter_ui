-- ─── PROCEDURE→FUNCTION: crewchat_deletemessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletemessage(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_deletemessage(
    IN messageno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_Messages WHERE MessageNo = crewchat_deletemessage.messageno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
