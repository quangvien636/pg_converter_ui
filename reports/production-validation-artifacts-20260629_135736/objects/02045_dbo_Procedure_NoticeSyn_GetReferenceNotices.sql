-- ─── PROCEDURE→FUNCTION: noticesyn_getreferencenotices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getreferencenotices(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getreferencenotices(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT Department, Position, Name, ReadDate
	FROM public."NoticeSynReference"
	WHERE NoticeNo = noticesyn_getreferencenotices.noticeno ORDER BY ReadDate ASC
	
	
END;
------------------------------------ ---------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
