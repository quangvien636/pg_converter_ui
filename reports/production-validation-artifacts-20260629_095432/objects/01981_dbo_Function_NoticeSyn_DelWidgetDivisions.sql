-- ─── FUNCTION: noticesyn_delwidgetdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_delwidgetdivisions(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_delwidgetdivisions(
    divisionno integer
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
