-- ─── PROCEDURE→FUNCTION: schedule_deletedivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletedivision();
CREATE OR REPLACE FUNCTION public.schedule_deletedivision(
) RETURNS void
AS $function$
DECLARE
    ndivisionno integer;
BEGIN



	
		FOR _rec IN SELECT VALUE FROM public."UF_TEXT_SPLIT"(DivisionNo,',')
LOOP
    ndivisionno := _rec.value;

	BEGIN;
		DELETE FROM ScheduleDivisions WHERE DivisionNo = CONVERT(INT,nDivisionNo)
			END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
