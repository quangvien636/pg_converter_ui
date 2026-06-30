-- ─── PROCEDURE→FUNCTION: crewchat_deleteattachfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deleteattachfile(integer);
CREATE OR REPLACE FUNCTION public.crewchat_deleteattachfile(
    IN attachno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_Attach WHERE AttachNo = crewchat_deleteattachfile.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
