-- ─── PROCEDURE→FUNCTION: crewchat_getversion ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getversion();
CREATE OR REPLACE FUNCTION public.crewchat_getversion(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF ClientType = 'PC' THEN
		RETURN QUERY
		SELECT PCVersion FROM CrewChat_Versions
	END IF;
	ELSIF ClientType = 'Android' THEN
		RETURN QUERY
		SELECT AndroidVersion FROM CrewChat_Versions
	END IF;
	ELSIF ClientType = 'iOS' THEN
		RETURN QUERY
		SELECT iOSVersion FROM CrewChat_Versions
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
