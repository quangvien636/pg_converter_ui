-- ─── PROCEDURE→FUNCTION: noticesyn_delwidgetdivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_delwidgetdivisions(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_delwidgetdivisions(
    IN divisionno integer
) RETURNS void
AS $function$
BEGIN
UPDATE NoticeSyn_Divisions SET ViewMode = 0 WHERE DivisionNo = noticesyn_delwidgetdivisions.divisionno;
---------------------------////////////////////////////////////-------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
