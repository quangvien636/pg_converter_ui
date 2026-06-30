-- ─── FUNCTION: noticesyn_addwidgetdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_addwidgetdivisions(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_addwidgetdivisions(
    divisionno integer
) RETURNS void
AS $function$
BEGIN
UPDATE NoticeSyn_Divisions SET ViewMode = 1 WHERE DivisionNo = noticesyn_addwidgetdivisions.divisionno;

------------------/////////////////////////////////-------------

--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
