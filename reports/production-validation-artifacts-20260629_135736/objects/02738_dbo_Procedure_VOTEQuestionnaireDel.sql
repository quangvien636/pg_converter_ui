-- ─── PROCEDURE→FUNCTION: votequestionnairedel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.votequestionnairedel(integer);
CREATE OR REPLACE FUNCTION public.votequestionnairedel(
    IN id integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTEQuestionnaire WHERE MasterID = votequestionnairedel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
