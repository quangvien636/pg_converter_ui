-- ─── PROCEDURE→FUNCTION: main_initialwidgetplacements_defaultsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_initialwidgetplacements_defaultsetting(integer);
CREATE OR REPLACE FUNCTION public.main_initialwidgetplacements_defaultsetting(
    IN boardno integer
) RETURNS void
AS $function$
BEGIN


	delete from main_initialwidgetplacements
	
	insert into main_initialwidgetplacements
	select moduserno
	,moddate
	,widgetno
	,isfixed
	,left
	,top
	,width
	,height from main_widgetplacements
	where boardno = main_initialwidgetplacements_defaultsetting.boardno
	
	delete from main_dashboards;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
